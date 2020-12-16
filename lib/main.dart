import 'package:flutter/material.dart';
import 'package:otras_rokas/navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otras Rokas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Navigation(),
    );
  }
}
