import 'package:flutter/material.dart';
import 'package:otras_rokas/services/database.dart';

enum CatalogItem {
  animals,
  clothes,
  electrical,
  for_home,
  for_kids,
  free,
  other,
  real_estate,
  transport,
  work,
}

class Catalog extends StatelessWidget {
  final Database database = Database();
  final List<String> categories = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> grid = List.generate(
        CatalogItem.values.length,
        (index) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.network(
                      'https://via.placeholder.com/184/FFFFFF?text=${CatalogItem.values[index]}'),
                ),
              ),
            ));

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: GridView.count(
        crossAxisCount: 2,
        children: grid,
      ),
    );
  }
}
