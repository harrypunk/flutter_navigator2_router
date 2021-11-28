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
