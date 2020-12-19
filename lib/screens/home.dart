import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = List.generate(10, (index) => _buildItemPage(index));
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: PageView.builder(
        itemCount: pages.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => pages[index],
      ),
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.heart_fill),
        onPressed: () {},
      ), // Add to favorite button
    );
  }

  _buildItemPage(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text('$index'),
        ),
      ),
    );
  }
}
