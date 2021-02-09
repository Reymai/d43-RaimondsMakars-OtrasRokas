import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlatButton(
          child: Text('Logout'),
          onPressed: () => _logOut(context),
        ),
      ),
    );
  }

  _logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _checkAuthentication(context);
  }

  _checkAuthentication(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is NOT signed in!');
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    });
  }
}
