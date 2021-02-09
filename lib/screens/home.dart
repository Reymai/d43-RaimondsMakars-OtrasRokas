import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool _inFavorite = false;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = List.generate(10, (index) => _buildItemPage(index));
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => database.addAd(ad),
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: pages.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => pages[index],
      ),
      backgroundColor: Colors.grey[300],
    );
  }

  _buildItemPage(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          child: FavoriteButton(),
          onTap: () {
            // TODO: Navigation to the item
          },
        ),
      ),
    );
  }

  _logOut() async {
    await FirebaseAuth.instance.signOut();
    await _checkAuthentication();
  }

  _checkAuthentication() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is NOT signed in!');
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    });
  }
}

class FavoriteButton extends StatefulWidget {
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // move to right bottom angle
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(blurRadius: 1)],
            ),
            child: IconButton(
              icon: Icon(
                // dynamically change icon
                _inFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: Colors.red,
              ),
              onPressed: () => setState(() {
                _invertFavoriteState();
              }),
              iconSize: 40,
            ),
          ),
        ),
      ],
    );
  }
}

_invertFavoriteState() {
  _inFavorite = !_inFavorite;
}
