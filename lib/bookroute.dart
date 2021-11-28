import 'dart:developer';
import 'package:flutter/material.dart';
import 'book.dart';
import 'package:learn_fl_router/bookdetail.dart';
import 'package:learn_fl_router/booklistscreen.dart';
import 'package:learn_fl_router/unknowscreen.dart';

class BookRoutePath {
  final int? id;
  final bool isUnknow;

  BookRoutePath.home()
      : id = null,
        isUnknow = false;

  BookRoutePath.details(this.id) : isUnknow = false;

  BookRoutePath.unknow()
      : id = null,
        isUnknow = true;

  bool get isHomePage => id == null;

  bool get isDetailPage => id != null;
}

class BookRouterDelegate extends RouterDelegate<BookRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  @override
  final GlobalKey<NavigatorState>? navigatorKey;

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  Book? _selectedBook;
  bool show404 = false;

  List<Book> books = [
    Book("Left hand of Dark", "Le Guin"),
    Book("Too like lightning", "Palmer"),
    Book("Kindred", "Butler"),
  ];

  void _handleBookTapped(Book? book) {
    _selectedBook = book;
    notifyListeners();
  }

  @override
  BookRoutePath? get currentConfiguration {
    if (show404) {
      return BookRoutePath.unknow();
    }

    return _selectedBook == null
        ? BookRoutePath.home()
        : BookRoutePath.details(books.indexOf(_selectedBook!));
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(
          child: BookListScreen(books: books, onTapped: _handleBookTapped),
          key: const ValueKey("BooksListPage"),
        ),
        if (show404)
          const MaterialPage(child: UnknowScreen(), key: ValueKey("unknowpage"))
        else if (_selectedBook != null)
          BookDetailPage(book: _selectedBook!),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        log("route did pop true", name: "bookapp");
        _selectedBook = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BookRoutePath configuration) async {
    if (configuration.isUnknow) {
      _selectedBook = null;
      show404 = true;
      return;
    }

    if (configuration.isDetailPage) {
      if (configuration.id! < 0 || configuration.id! > books.length - 1) {
        show404 = true;
        return;
      }

      _selectedBook = books[configuration.id!];
    } else {
      _selectedBook = null;
    }

    show404 = false;
  }
}

class BookRouteInformationParser extends RouteInformationParser<BookRoutePath> {
  @override
  Future<BookRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      return BookRoutePath.home();
    }

    // Handle '/book/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'book') return BookRoutePath.unknow();
      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return BookRoutePath.unknow();
      return BookRoutePath.details(id);
    }

    // Handle unknown routes
    return BookRoutePath.unknow();
  }

  @override
  RouteInformation? restoreRouteInformation(BookRoutePath configuration) {
    if (configuration.isUnknow) {
      return const RouteInformation(location: '/404');
    }
    if (configuration.isHomePage) {
      return const RouteInformation(location: '/');
    }
    if (configuration.isDetailPage) {
      return RouteInformation(location: '/book/${configuration.id}');
    }
    return null;
  }
}
