import 'package:flutter/material.dart';
import 'package:learn_fl_router/bookroute.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BooksAppState();
}

class BooksAppState extends State<MyApp> {
  final BookRouterDelegate _routerDelegate = BookRouterDelegate();
  final BookRouteInformationParser _routeInformationParser =
      BookRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routeInformationParser: _routeInformationParser,
        title: "Books App",
        routerDelegate: _routerDelegate);
  }
}
