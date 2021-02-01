import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

bool signInWithEmail = false;

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(); // controller for email field
  final TextEditingController _passwordController =
      TextEditingController(); // controller for password field

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            signInWithEmail
                ? Column(
                    children: [
                      Container(
                        width: 310,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    helperText: 'Enter your Email Address'),
                                autofillHints: [AutofillHints.email],
                                controller: _emailController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (email) => _emailValidator(email),
                                autofocus: true,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox.fromSize(
                                size: Size.fromHeight(10),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    helperText:
                                        'At least 6 characters, 1 UPPERCASE, 1 lowercase, 1 d1g1t'),
                                autofillHints: [AutofillHints.password],
                                controller: _passwordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (password) =>
                                    _passwordValidator(password),
                                obscureText: true,
                                autocorrect: false,
                                enableSuggestions: false,
                              ),
                              Container(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
            signInWithEmail
                ? Divider(
                    height: 12,
                  )
                : Container(),
            SignInButton(
              Buttons.Google,
              onPressed: () => _authenticate('Google', context),
            ),
            SignInButtonBuilder(
              text: 'Sign in Anonymously',
              icon: Icons.account_circle_outlined,
              onPressed: () => _authenticate('Anonymously', context),
              backgroundColor: Colors.blueGrey[700],
            )
          ],
        ),
      ),
    );
  }

  _authenticate(String method, BuildContext context,
      {String email, String password}) async {
    switch (method) {
      case 'Email':
        {
          if (signInWithEmail == false) {
            setState(() {
              signInWithEmail = true;
            });
          } else {
            _signInWithEmail(email, password);
          }
          break;
        }
      case 'Google':
        {
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
    await _checkAuthentication(context);
  }

  _signInWithEmail(String email, String password) async {
    print('Email: $email, password: $password');
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('email already in use');
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
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

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print(credential.asMap().toString());

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  _signInAnonymously() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
  }

  _checkAuthentication(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user != null) {
        print('User is signed in!');
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  _emailValidator(String email) {
    RegExp emailRegEx = RegExp(r"[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");

    if (!emailRegEx.hasMatch(email)) {
      return 'Wrong email';
    }
    return null;
  }

  _passwordValidator(
    String password,
  ) {
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
}
