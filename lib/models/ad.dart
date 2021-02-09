import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Ad {
  final String path;
  final String label;
  final String text;
  final double price;
  final Map<String, dynamic> specs;
  final List<String> images;
  final GeoPoint geoPoint;
  final User user;

  Ad({
    this.path,
    this.label,
    this.text,
    this.price,
    this.specs,
    this.images,
    this.geoPoint,
    this.user,
  });
}
