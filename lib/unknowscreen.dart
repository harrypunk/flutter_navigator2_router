import 'package:flutter/material.dart';

class UnknowScreen extends StatelessWidget{
  const UnknowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Text("404 not found"),
    );
  }
}