import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otras_rokas/services/database.dart';

class Catalog extends StatelessWidget {
  final Database database = Database();
  final List<String> categories = [];
  final Future<String> categoryJson =
      rootBundle.loadString('./lib/models/category.json');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: FutureBuilder(
        future: categoryJson,
        builder: (context, AsyncSnapshot<String> snapshot) =>
            snapshot.hasData && snapshot.data != null
                ? GridView.count(
                    crossAxisCount: 2,
                    children: _generateList(jsonDecode(snapshot.data!)),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }

  List<Widget> _generateList(Map<String, dynamic> catalogItem) {
    print(catalogItem['Category']);
    catalogItem = catalogItem['Category'];
    return List.generate(
        catalogItem.length,
        (index) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.network(
                      'https://via.placeholder.com/184/FFFFFF?text=${catalogItem.keys.elementAt(index)}'),
                ),
              ),
            ));
  }
}
