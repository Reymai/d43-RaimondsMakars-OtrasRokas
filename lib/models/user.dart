import 'package:flutter/material.dart';

class User {
  final String email;
  final String name;
  final String surname;
  final String phoneNumber;
  final NetworkImage avatar;
  final List<String> ads;

  User({
    this.email,
    this.name,
    this.surname,
    this.phoneNumber,
    this.avatar,
    this.ads,
  });
}
