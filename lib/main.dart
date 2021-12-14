import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final delegate = MyRouteDelegate();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: delegate,
      routeInformationParser: MyRouteParser(),
    );
  }
}

class MyRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    log("parse route ${routeInformation.location}");
    final location = routeInformation.location ?? "/";
    return SynchronousFuture(location);
  }

  @override
  RouteInformation? restoreRouteInformation(String configuration) {
    log("restore route $configuration");
    return RouteInformation(location: configuration);
  }
}

class MyRouteDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  final _stack = <String>[];

  @override
  String? get currentConfiguration => _stack.isNotEmpty ? _stack.last : null;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [for (final url in _stack) getPage(url)],
      onPopPage: (route, result) {
        log("on pop page $result");
        if (_stack.isNotEmpty) {
          _stack.removeLast();
          notifyListeners();
        }
        return route.didPop(result);
      },
    );
  }

  Page getPage(String url) {
    Widget target;
    if (url == "pageA") {
      target = const PageA();
    } else if (url == "pageB") {
      target = const PageB();
    } else if (url == "/") {
      target = const PageHome();
    } else {
      target = const NotFound();
    }
    return MaterialPage(
        name: url,
        arguments: null,
        child: Scaffold(
          appBar: AppBar(),
          body: target,
        ));
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    log("set new route path $configuration");
    if (configuration == "/") {
      _stack.clear();
    }
    if (_stack.isEmpty || configuration != _stack.last) {
      _stack.add(configuration);
      notifyListeners();
    }
    return SynchronousFuture<void>(null);
  }
}

class PageHome extends StatelessWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Home"),
          MaterialButton(
            onPressed: () {
              Router.of(context).routerDelegate.setNewRoutePath("pageA");
            },
            child: const Text("go to A"),
          )
        ],
      ),
    );
  }
}

class PageA extends StatelessWidget {
  const PageA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Page A",
          textAlign: TextAlign.center,
        ),
        MaterialButton(
          onPressed: () {
            Router.of(context).routerDelegate.setNewRoutePath("/");
          },
          child: const Text("go home"),
        ),
        MaterialButton(
          onPressed: () {
            Router.of(context).routerDelegate.setNewRoutePath("pageB");
          },
          child: const Text("go to B"),
        ),
        MaterialButton(
          onPressed: () {
            Router.of(context).routerDelegate.setNewRoutePath("pageabc");
          },
          child: const Text("Page abc not found"),
        ),
      ],
    );
  }
}

class PageB extends StatelessWidget {
  const PageB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Page b"),
    );
  }
}

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Not found"),
          MaterialButton(
            onPressed: () {
              Router.of(context).routerDelegate.setNewRoutePath("/");
            },
            child: const Text("go home"),
          )
        ],
      ),
    );
  }
}
