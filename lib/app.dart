import 'package:flutter/material.dart';
import 'package:otras_rokas/screens/auth.dart';
import 'package:otras_rokas/screens/home.dart';

class App extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otras Rokas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Auth(),
      routes: {
        '/home': (context) => Home(),
        '/auth': (context) => Auth(),
      },
      navigatorKey: navigatorKey,
    );
  }
}
