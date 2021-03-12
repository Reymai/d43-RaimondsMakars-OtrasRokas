import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otras_rokas/services/database.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool signInWithEmail = false;

  final TextEditingController _emailController =
      TextEditingController(); // controller for email field
  final TextEditingController _passwordController =
      TextEditingController(); // controller for password field

  final Database _database = Database();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print('User is signed in!');
        Navigator.of(context).pushReplacementNamed('/navigation');
      }
    });
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              signInWithEmail
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          //TODO: Add padding
                          ),
                      child: AutofillGroup(
                        onDisposeAction: AutofillContextAction.commit,
                        child: Form(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    //TODO: Add padding
                                    ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'E-mail',
                                    helperText: 'Enter your E-mail address',
                                  ),
                                  autofillHints: [AutofillHints.email],
                                  controller: _emailController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  autofocus: true,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (email) => _emailValidator(email!),
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  helperText:
                                      'At least 6 characters, 1 UPPERCASE, 1 lowercase, 1 d1g1t',
                                ),
                                autofillHints: [AutofillHints.password],
                                controller: _passwordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                validator: (password) =>
                                    _passwordValidator(password!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
              SignInButton(
                Buttons.Email,
                onPressed: () => _authenticate('Email', context,
                    email: _emailController.text,
                    password: _passwordController.text),
              ),
              Divider(),
              SignInButton(
                Buttons.Google,
                onPressed: () async => await _authenticate('Google', context),
              ),
              SignInButtonBuilder(
                text: 'Sign in Anonymously',
                icon: Icons.account_circle_outlined,
                onPressed: () => _authenticate('Anonymously', context),
                backgroundColor: Colors.blueGrey[700]!,
              )
            ],
          ),
        ),
      ),
    );
  }

  _emailValidator(String email) {
    RegExp emailRegExp = RegExp(r"[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");

    if (!emailRegExp.hasMatch(email)) {
      return 'Wrong email format';
    }
    return;
  }

  _passwordValidator(String password) {
    RegExp lowercase = new RegExp(r'[a-z]');
    RegExp uppercase = new RegExp(r'[A-Z]');
    RegExp digits = new RegExp(r'[0-9]');

    print(password);
    if (password.length < 6) {
      return 'Password should contain at least 6 characters';
    }
    if (!lowercase.hasMatch(password)) {
      return 'password should contain at least 1 lowercase letter';
    }
    if (!uppercase.hasMatch(password)) {
      return 'password should contain at least 1 UPPERCASE letter';
    }
    if (!digits.hasMatch(password)) {
      return 'password should contain at least 1 d1g1t';
    }
  }

  _authenticate(String method, BuildContext context,
      {String? email, String? password}) async {
    switch (method) {
      case 'Email':
        {
          if (signInWithEmail == false) {
            setState(() {
              signInWithEmail = true;
            });
          } else {
            await _signInWithEmail(email!, password!);
          }
          break;
        }
      case 'Google':
        {
          print('Google');
          await _signInWithGoogle();
          break;
        }
      case 'Anonymously':
        {
          await _signInAnonymously();
          break;
        }
      default:
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Something went wrong!')));
    }
  }

  _signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await _database.addGoogleUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('email already in use');
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            //TODO: send error to password form field
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Wrong password!'),
                action: SnackBarAction(
                  label: 'Forgot password?',
                  onPressed: () => _forgotPassword(email),
                ),
              ),
            );
            print('Wrong password provided for that user.');
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  _forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  _signInWithGoogle() async {
    print('1');

    try {
      final GoogleSignInAccount? googleUser = await (GoogleSignIn(
        scopes: ['email', 'profile'],
      ).signIn());

      print('1');

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      print('1');

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ) as GoogleAuthCredential;
      print(credential.asMap().toString());
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await _database.addGoogleUser(userCredential.user!);
    } catch (e) {
      print(e);
    }
  }

  _signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      await _database.addGoogleUser(userCredential.user!);
    } catch (e) {
      print(e);
    }
  }
}
