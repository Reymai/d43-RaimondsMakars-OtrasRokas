import 'package:flutter/material.dart';

class User {
  final String name;
  final String surname;
  final String phoneNumber;
  final NetworkImage avatar;
  final List<String> ads;

  User({this.name, this.surname, this.phoneNumber, this.avatar, this.ads});
}
