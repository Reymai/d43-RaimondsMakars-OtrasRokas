import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otras_rokas/models/ad.dart';
import 'package:otras_rokas/services/database.dart';

bool _inFavorite = false;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Database database;
  late FirebaseAuth auth;
  late Future<List<Ad>> ads;

  @override
  void initState() {
    super.initState();
    database = Database();
    auth = FirebaseAuth.instance;
    _updateAds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random(Timestamp.now().millisecondsSinceEpoch);
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => database.addAd(Ad(
                author: auth.currentUser!.uid,
                path: 'items/animals',
                label: 'Test label',
                text: '',
                price: double.parse(random.nextDouble().toStringAsFixed(2)),
                specs: {'test': 'test', 'test 42': 42},
                geoPoint: GeoPoint(56.9715833, 23.9890811),
                images: [
                  'https://via.placeholder.com/184/FFFFFF?text=${random.nextInt(999)}',
                  'https://via.placeholder.com/184/FFFFFF?text=${random.nextInt(999)}',
                  'https://via.placeholder.com/184/FFFFFF?text=${random.nextInt(999)}',
                  'https://via.placeholder.com/184/FFFFFF?text=${random.nextInt(999)}',
                ])),
          ),
        ],
      ),
      body: FutureBuilder(
          future: ads,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  print(snapshot.data!.length);
                  return _buildItem(context, snapshot.data[index]);
                },
              );
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Something went wrong!\n${snapshot.error}');
            }
            return LinearProgressIndicator();
          }),
      backgroundColor: Colors.grey[300],
    );
  }

  _buildItem(BuildContext context, Ad data) {
    return AspectRatio(
      aspectRatio: 6.5 / 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            child: Column(
              children: [
                Text(data.label!),
                CarouselSlider(
                  items: List.generate(data.images!.length,
                      (index) => Image.network(data.images!.elementAt(index))),
                  options: CarouselOptions(
                      autoPlay: false,
                      enableInfiniteScroll: true,
                      scrollDirection: Axis.horizontal),
                ),
                Text(data.text!),
              ],
            ),
            onTap: () {
              // TODO: Navigation to the item
            },
          ),
        ),
      ),
    );
  }

  _updateAds() {
    setState(() {
      ads = database.getAd();
    });
    return ads;
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
