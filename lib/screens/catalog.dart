import 'dart:ui';

import 'package:flutter/material.dart';

class Catalog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> grid = List.generate(
      10,
      (index) => Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Image.network(
                'https://via.placeholder.com/184/FFFFFF?text=${index + 1}'),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: GridView.count(
        crossAxisCount: 2,
        children: grid,
      ),
    );
  }
}
