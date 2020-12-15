import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: PageView.builder(
        itemCount: 6,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => _buildItemPage(index),
      ),
      backgroundColor: Colors.grey,
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
