import 'package:flutter/material.dart';

import 'book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book _book;
  const BookDetailScreen({Key? key, required Book book})
      : _book = book,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("book ${_book.title}"),
    );
  }
}

class BookDetailPage extends Page {
  final Book book;

  BookDetailPage({
    required this.book,
  }) : super(key: ValueKey(book));

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, animation2) {
        final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
        final curveTween = CurveTween(curve: Curves.easeIn);
        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: BookDetailScreen(
            key: ValueKey(book),
            book: book,
          ),
        );
      },
      settings: this,
    );
  }
}
