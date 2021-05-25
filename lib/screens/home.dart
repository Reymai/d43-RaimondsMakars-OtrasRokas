import 'dart:math';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otras_rokas/models/ad.dart';
import 'package:otras_rokas/services/database.dart';
import 'package:unsplash_client/unsplash_client.dart';

bool _inFavorite = false;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Database database;
  late FirebaseAuth auth;
  late Future<List<Ad>> ads;
  late TransformationController controller;
  late final UnsplashClient client;

  @override
  void initState() {
    super.initState();
    database = Database();
    auth = FirebaseAuth.instance;
    controller = TransformationController();
    client = UnsplashClient(
      settings: ClientSettings(
          credentials: AppCredentials(
        accessKey: 'K7JOdSGi525vt8PvluA_Sy6F5UdrjSKI1c3B_spHs6c',
        secretKey: 'Il964U6qW7YerKdG-Y_depES3AUDFou3NZRneDeO-DY',
      )),
    );
    _updateAds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Last ads'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.pushNamed(context, '/creating');
              // _createMockedAd();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _updateAds(),
        child: FutureBuilder(
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
      ),
      backgroundColor: Colors.grey[300],
    );
  }

  _buildItem(BuildContext context, Ad data) {
    return AspectRatio(
      aspectRatio: 6.5 / 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Material(
          elevation: 5,
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      data.label!,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CarouselSlider(
                          items: List.generate(
                            data.images!.length,
                            (index) => InteractiveViewer(
                              alignPanAxis: true,
                              scaleEnabled: true,
                              child: Image.network(
                                data.images!.elementAt(index),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            aspectRatio: 1.4,
                            enlargeCenterPage: true,
                            autoPlay: false,
                            enableInfiniteScroll: true,
                            scrollDirection: Axis.horizontal,
                            viewportFraction: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Expanded(
                    flex: 1,
                    child: RichText(
                      text: data.text!.length < 315
                          ? TextSpan(
                              text: data.text,
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .merge(TextStyle(fontSize: 16)),
                            )
                          : TextSpan(
                              text: data.text!.substring(0, 315),
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .merge(TextStyle(fontSize: 16)),
                              children: [
                                TextSpan(
                                    text: ' ',
                                    style: DefaultTextStyle.of(context).style),
                                TextSpan(
                                  text: 'Read more...',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Divider(
                          thickness: 1,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              '€ ${data.price}',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
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

  _createMockedAd() async {
    Random random = Random(Timestamp.now().millisecondsSinceEpoch);

    final photos = await client.photos
        .random(query: 'apartments', count: (random.nextInt(10) + 1))
        .goAndGet();
    List<String> photoList = [];
    photos.forEach((element) {
      photoList.add(element.urls.regular.toString());
    });
    database.addAd(
      Ad(
        author: auth.currentUser!.uid,
        path: 'items/animals',
        label: 'Test label' * (random.nextInt(5) + 1),
        text:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum rhoncus velit vitae convallis. In hac habitasse platea dictumst. Fusce accumsan eu ex ac maximus.' *
                (random.nextInt(10) + 1),
        price:
            (random.nextDouble() * (random.nextInt(99) + 1)).toStringAsFixed(2),
        specs: {'test': 'test', 'test 42': 42},
        geoPoint: GeoPoint(56.9715833, 23.9890811),
        images: photoList,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
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
