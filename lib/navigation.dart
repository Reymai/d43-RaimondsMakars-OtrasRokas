import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otras_rokas/screens/catalog.dart';
import 'package:otras_rokas/screens/favorite.dart';
import 'package:otras_rokas/screens/home.dart';
import 'package:otras_rokas/screens/profile.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _index = 0;
  var _body = [
    Home(),
    Catalog(),
    Favorite(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ), // Home
          BottomNavigationBarItem(
            label: 'Catalog',
            icon: Icon(Icons.apps_outlined),
            activeIcon: Icon(Icons.apps_sharp),
          ), // Catalog
          BottomNavigationBarItem(
            label: 'Favorite',
            icon: Icon(CupertinoIcons.heart),
            activeIcon: Icon(CupertinoIcons.heart_fill),
          ), // Favorite
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
          ), // Profile
        ],
        onTap: (navIndex) {
          setState(() {
            _index = navIndex;
          });
        },
      ),
    );
  }
}
