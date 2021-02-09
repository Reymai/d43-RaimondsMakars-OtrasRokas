import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otras_rokas/models/ad.dart';
import 'package:otras_rokas/models/user.dart';

class Database {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference items = FirebaseFirestore.instance.collection('items');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future addUser(User user) {
    return users.doc().set({
      'name': user.name,
      'surname': user.surname,
      'phone_number': user.phoneNumber ?? null,
      'avatar': user.avatar ?? null,
      'ads': user.ads ?? null,
    });
  }

  Future addAd(Ad ad) async {
    return items.doc().set({
      'path': ad.path,
      'label': ad.label,
      'text': ad.text,
      'price': ad.price,
      'specs': ad.specs,
      'images': ad.images,
      'geo': ad.geoPoint,
      'author': ad.user,
    });
  }

  getAd() async {
    print('PATH: ' + (items.path ?? 'null'));
  }
}
