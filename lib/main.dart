import 'package:flutter/material.dart';
import 'package:learn_fl_router/bookdetail.dart';
import 'package:learn_fl_router/booklistscreen.dart';
import 'package:learn_fl_router/unknowscreen.dart';

import 'book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BooksAppState();
}

class BooksAppState extends State<MyApp> {
  Book? _selectedBook;
  bool show404 = false;

  List<Book> books = [
    Book("Left hand of Dark", "Le Guin"),
    Book("Too like lightning", "Palmer"),
    Book("Kindred", "Butler"),
  ];

  void _handleBookTapped(Book? book) {
    setState(() {
      _selectedBook = book;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Books App",
      home: Navigator(
        pages: [
          MaterialPage(
            child: BookListScreen(books: books, onTapped: _handleBookTapped),
            key: const ValueKey("BooksListPage"),
          ),
          if (show404)
            const MaterialPage(
                child: UnknowScreen(), key: ValueKey("unknowpage"))
          else if (_selectedBook != null)
            MaterialPage(
              key: ValueKey(_selectedBook),
              child: BookDetailScreen(book: _selectedBook!),
            )
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
    );
  }
}
