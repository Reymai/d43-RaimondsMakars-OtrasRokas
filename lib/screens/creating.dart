import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Creating extends StatefulWidget {
  @override
  _CreatingState createState() => _CreatingState();
}

class _CreatingState extends State<Creating> {
  late TextEditingController _labelController;
  late TextEditingController _textController;
  late TextEditingController _priceController;
  late int _index;
  final Future<String> categoryJson =
      rootBundle.loadString('./lib/models/category.json');
  List<String> category = [];
  late String label;
  late String text;
  List<File> photos = [];
  List<String> specsResult = [];
  late String price;

  var colors = [
    Colors.deepPurple,
    Color(0xFFB7683A),
    Color(0xFF3A89B7),
    Color(0xFFB73A89),
    Color(0xFFA63AB7),
    Color(0xFFB73A4B),
    Color(0xFF3A89B7),
  ];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _textController = TextEditingController();
    _priceController = TextEditingController();
    _index = 0;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var _body = [
      _showCategoryChooser(),
      _showLabelEditor(),
      _showTextEditor(),
      _showPhotoChooser(),
      _showSpecsEditor(),
      _showPriceEditor(),
      _showGeoChooser()
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_index == 0) {
          return true;
        } else {
          setState(() {
            _index -= 1;
          });
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: colors.elementAt(_index),
        body: Container(
          height: size.height,
          width: size.width,
          child: _body[_index],
        ),
      ),
    );
  }

  Widget _showCategoryChooser() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
            future: categoryJson,
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> json =
                    jsonDecode(snapshot.data!)['Category'];
                if (category.length == 0) {
                  category.add(json.keys.elementAt(0));
                }
                print(category);
                return Column(
                  children: List<Widget>.generate(
                    category.length,
                    (index) => DropdownButton(
                      value: category.elementAt(index),
                      items: _getKeysOrValuesFromJson(
                              index > 0 ? json[category[0]] : json)
                          .map<DropdownMenuItem<String>>(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newCategory) => setState(() {
                        category[index] = newCategory!;
                        print('Index: $index, length: ${category.length}');
                        if (index < category.length - 1) {
                          category.removeRange(index + 1, category.length);
                        }
                        late List temp;
                        Map<String, dynamic> tempJson = json;
                        category.forEach((_category) {
                          temp = [];
                          temp.add(_category);
                          if (_hasChild(json)) {
                            try {
                              category.add(json[newCategory].keys.elementAt(0));
                              tempJson = tempJson[_category];
                            } catch (e) {
                              category.add(json[newCategory].elementAt(0));
                              print(tempJson[_category]);
                            }
                          }
                        });
                      }),
                    ),
                  ),
                );
              }
              return CircularProgressIndicator();
            }),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 65.0),
            child: _showInkButton(
              color: colors.elementAt(1),
              icon: Icon(
                Icons.navigate_next,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showLabelEditor() {
    return Padding(
      padding: EdgeInsets.all(65.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'Choose label for Your ad:',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0),
                child: TextFormField(
                  controller: _labelController,
                  maxLength: 30,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Label',
                    hintText: 'ex. I am selling a ',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                    fillColor: Color(0xFF833C10),
                    filled: true,
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  autofocus: true,
                  onChanged: (_text) => setState(() {
                    label = _text;
                  }),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: _showNavigationButtons(),
          ),
        ],
      ),
    );
  }

  _showTextEditor() {
    return Padding(
      padding: EdgeInsets.all(65.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'Enter text for Your ad:',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              TextField(
                controller: _textController,
                maxLength: 1000,
                minLines: 1,
                maxLines: 10,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Text',
                  hintText: 'ex. I am selling a garage 5x8 meters ...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                  fillColor: Color(0xFF005c87),
                  filled: true,
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                autofocus: true,
                onChanged: (value) => setState(() {
                  text = value;
                }),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: _showNavigationButtons(),
          )
        ],
      ),
    );
  }

  _showPhotoChooser() {
    List<Widget> images = [];
    if (photos.length > 0) {
      images = List.generate(
          photos.length,
          (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Stack(children: [
                    Image.file(
                      photos[index],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            height: 30,
                            width: 30,
                            color: Colors.grey,
                            child: IconButton(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(bottom: 0.5),
                              color: Colors.black,
                              icon: Icon(Icons.close),
                              onPressed: () =>
                                  setState(() => photos.removeAt(index)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
          growable: true);
    }
    images.add(
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
          child: InkWell(
            child: Icon(Icons.add_a_photo),
            onTap: () => _pickFiles(),
          ),
        ),
      ),
    );
    return SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.only(top: 25),
      child: Column(
        children: [
          Text(
            'Pick photos:',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          Wrap(
            direction: Axis.horizontal,
            children: images,
          ),
          _showNavigationButtons(),
        ],
      ),
    );
  }

  _showSpecsEditor() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Table(
          children: [
            TableRow(children: [
              Text('test'),
            ])
          ],
        ),
        _showNavigationButtons(),
      ],
    );
  }

  _showPriceEditor() {
    return Padding(
      padding: EdgeInsets.all(65.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'Choose price for Your ad:',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0),
                child: TextFormField(
                  controller: _priceController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: '42.42',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                    prefixIcon: Icon(
                      Icons.euro,
                      color: Colors.white,
                    ),
                    filled: true,
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  autofocus: true,
                  onChanged: (_price) => setState(() {
                    price = _price;
                  }),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: _showNavigationButtons(),
          ),
        ],
      ),
    );
  }

  _showGeoChooser() {}

  _showInkButton({required Color color, required Icon icon}) {
    return Ink(
      decoration: ShapeDecoration(
        shadows: [BoxShadow(offset: Offset(0.5, 1), blurRadius: 1.5)],
        shape: CircleBorder(),
        color: color,
      ),
      child: IconButton(
        icon: icon,
        iconSize: 42,
        onPressed: () => setState(() {
          if (icon.icon == Icons.navigate_next) {
            _index += 1;
          } else {
            _index -= 1;
          }
        }),
      ),
    );
  }

  _showNavigationButtons() {
    if (_index > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _showInkButton(
            color: colors.elementAt(_index - 1),
            icon: Icon(
              Icons.navigate_before,
              color: Colors.white,
            ),
          ),
          _showInkButton(
            color: colors.elementAt(_index + 1),
            icon: Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (result != null) {
        List<File> _files = result.paths.map((path) => File(path!)).toList();
        setState(() {
          _files.forEach((element) {
            photos.add(element);
          });
        });
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Iterable<String> _getKeysOrValuesFromJson(dynamic json) {
    if (json == null) return Iterable.empty();
    try {
      return json.keys;
    } catch (e) {
      return Iterable.castFrom(json);
    }
  }

  _hasChild(json) {
    if (json == null || json.isEmpty) return false;
    return true;
  }
}
