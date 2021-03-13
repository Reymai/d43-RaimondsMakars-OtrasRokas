import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:otras_rokas/models/ad.dart';
import 'package:otras_rokas/models/user.dart' as local;

class Database {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference items = FirebaseFirestore.instance.collection('items');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future addUser(local.User user) {
    return users.doc(user.email).set({
      'full_name': user.name,
      'phone_number': user.phoneNumber ?? null,
      'avatar': user.avatar ?? null,
    });
  }

  Future addGoogleUser(firebase.User user) {
    return users.doc(user.uid).set({
      'full_name': user.displayName,
      'phone_number': user.phoneNumber ?? null,
      'avatar': user.photoURL ?? null,
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
      'author': ad.author,
      'timestamp': ad.timestamp,
    });
  }

  Future<List<Ad>> getAd() async {
    List<Ad> ads = [];
    try {
      await items.get().then(
            (value) => value.docs.forEach(
              (element) {
                ads.add(
                  Ad(
                    text: element.data()?['text'],
                    label: element.data()?['label'],
                    price: element.data()?['price'],
                    images:
                        List.from(element.data()?['images'], growable: true),
                    path: element.data()?['path'],
                    specs: element.data()?['specs'],
                    geoPoint: element.data()?['geo'],
                    author: element.data()?['author'],
                    timestamp: element.data()?['timestamp'],
                  ),
                );
              },
            ),
          );
    } catch (e) {
      throw e;
    }
    ads.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
    return ads;
  }
}
