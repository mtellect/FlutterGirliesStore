import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/app/progress.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/fbconn.dart';
import 'package:girlies/support/screens/add_categories.dart';

class EditProducts extends StatefulWidget {
  final String productKey;

  EditProducts({this.productKey});

  @override
  _AddProductsState createState() => new _AddProductsState();
}

class _AddProductsState extends State<EditProducts> {
  File imageOne, imageTwo, imageThree, imageFour;
  String imgOne, imgTwo, imgThree, imgFour;

  List<File> files = new List();
  List<String> filesURL = new List();
  List<String> _productCategories = new List();

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Map val2;

  TextEditingController productController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController sizeController = new TextEditingController();
  TextEditingController colorController = new TextEditingController();
  TextEditingController stockController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  static DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  static final reference = dbRef.child(AppData.categoriesDB);
  static final productRef = dbRef.child(AppData.productsDB);

  String _selectedCategory;
  String images;

  List fbImages;
  int maxImageNo = 10;
  bool selectSingleImage = false;

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Please wait...',
  );

  var progress1 = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Saving Please wait...',
  );

  Future<DataSnapshot> productSpecs() async {
    return await FirebaseDatabase.instance
        .reference()
        .child(AppData.productsDB)
        .child(widget.productKey)
        .once();
  }

  Future getProductSpecs() async {
    return await FirebaseDatabase.instance
        .reference()
        .child(AppData.productsDB)
        .child(widget.productKey)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      productController.text = map[AppData.productName];
      priceController.text = map[AppData.productPrice];
      sizeController.text = map[AppData.productSizesAvailable];
      colorController.text = map[AppData.productColorsAvailable];
      stockController.text = map[AppData.productNoInStock];
      descriptionController.text = map[AppData.productDescription];
      _selectedCategory = map[AppData.categoryName];

      images = map[AppData.productImagesURL]
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");

      fbImages = images.split(", ");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fbImages = null;
    _getCategories();
    getProductSpecs();
    super.initState();
  }

  initMultiPickUp() async {
    List resultList;
    int imageLength = fbImages.length == 0 ? 0 : fbImages.length;
    String error;
    try {
      resultList = await FlutterMultipleImagePicker.pickMultiImages(
          4 - imageLength, selectSingleImage);
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      if (error != null) {
        showInSnackBar(error);
        return;
      }

      //fbImages = resultList;
      for (int s = 0; s < resultList.length; s++) {
        fbImages.add(resultList[s]);
      }
      //showInSnackBar(resultList.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final multiImages = fbImages == null || fbImages.length == 0
        ? new Container()
        : new SizedBox(
            height: 150.0,
            width: screenSize.width,
            child: new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) => new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        new Image.file(
                          new File(fbImages[index].toString()),
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.cover,
                        ),
                        /*new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new GestureDetector(
                            onTap: () {
                              removeImageAt(index);
                            },
                            child: new CircleAvatar(
                              backgroundColor: Colors.red[900],
                              maxRadius: 12.0,
                              child: new Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 15.0,
                              ),
                            ),
                          ),
                        )*/
                      ],
                    ),
                  ),
              itemCount: fbImages.length,
            ),
          );

    var futureBuilder = new FutureBuilder(
      future: productSpecs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          /* Map<dynamic, dynamic> map = snapshot.data.value;
          productController.text = map[AppData.productName];
          priceController.text = map[AppData.productPrice];
          sizeController.text = map[AppData.productSizesAvailable];
          colorController.text = map[AppData.productColorsAvailable];
          stockController.text = map[AppData.productNoInStock];
          descriptionController.text = map[AppData.productDescription];
          _selectedCategory = map[AppData.categoryName];

          String images = map[AppData.productImagesURL]
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "");

          fbImages = images.split(", ");*/

          return new Container(
            margin: new EdgeInsets.only(bottom: 00.0),
            child: new ListView(
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: fbImages == null || fbImages.length == 0
                          ? new Container()
                          : new SizedBox(
                              height: 150.0,
                              width: screenSize.width,
                              child: new ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    new Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: new Stack(
                                        alignment: Alignment.topRight,
                                        children: <Widget>[
                                          fbImages[index]
                                                  .toString()
                                                  .contains("https")
                                              ? new Image.network(
                                                  fbImages[index],
                                                  width: 150.0,
                                                  height: 150.0,
                                                  fit: BoxFit.cover,
                                                )
                                              : new Image.file(
                                                  new File(fbImages[index]),
                                                  width: 150.0,
                                                  height: 150.0,
                                                  fit: BoxFit.cover,
                                                ),
                                          new Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new GestureDetector(
                                              onTap: () {
                                                removeImageAt(index);
                                              },
                                              child: new CircleAvatar(
                                                backgroundColor:
                                                    Colors.red[900],
                                                maxRadius: 12.0,
                                                child: new Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 15.0,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                itemCount: fbImages.length,
                              ),
                            ),
                    ),
                    new GestureDetector(
                      onTap: () {
                        /* fbImages.length == 4
                            ? showInSnackBar(
                                "Sorry Images cannot be more than 4.")
                            : initMultiPickUp();*/

                        fbImages.length == null
                            ? initMultiPickUp()
                            : fbImages.length == 4
                                ? showInSnackBar(
                                    "Sorry Images cannot be more than 4.")
                                : initMultiPickUp();
                      },
                      child: new Container(
                        height: 60.0,
                        margin: new EdgeInsets.only(top: 5.0),
                        child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Container(
                            width: screenSize.width,
                            margin: new EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 2.0),
                            height: 60.0,
                            decoration: new BoxDecoration(
                                color: MyApp.appColors[400],
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(20.0))),
                            child: new Center(
                                child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  ),
                                ),
                                new Text(
                                  "Update Images",
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              items: _productCategories.map((String val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              hint: Text("Please Select a Category"),
                              value: _selectedCategory,
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.black54),
                              onChanged: onChange)),
                    ),
                    new Divider(
                      height: 1.0,
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 12.0, bottom: 5.0),
                      child: new TextFormField(
                        controller: productController,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "Product Name",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
                      child: new TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "Set Price",
                          prefixText: "N ",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 5.0, bottom: 0.0),
                      child: new TextFormField(
                        controller: sizeController,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "Sizes Available",
                          hintText: "Eg. (2, 3, 4,5)",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
                      child: new TextFormField(
                        controller: colorController,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "Colors Available",
                          hintText: "Eg. (red, blue, green, pink)",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 0.0, bottom: 10.0),
                      child: new TextFormField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "No in Stock",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 0.0, bottom: 50.0),
                      child: new TextFormField(
                        controller: descriptionController,
                        maxLines: 4,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "Product Description",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return new Container(
            constraints: const BoxConstraints(maxHeight: 500.0),
            child: new Center(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    margin: new EdgeInsets.only(top: 00.0, bottom: 0.0),
                    height: 150.0,
                    width: 150.0,
                    child: new Image.asset(
                        'assets/images/no_internet_access.png')),
                new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Text(
                    "No internet access..",
                    style: new TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
              ],
            )),
          );
        } else {
          return new Center(child: new CircularProgressIndicator());
        }
      },
    );

    var streamBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.productsDB)
          .child(widget.productKey)
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FbConn fbconn = new FbConn(map);
          int length = map.keys.length;
          //print(map[AppData.productName]);
          productController.text = map[AppData.productName];
          priceController.text = map[AppData.productPrice];
          sizeController.text = map[AppData.productSizesAvailable];
          colorController.text = map[AppData.productColorsAvailable];
          stockController.text = map[AppData.productNoInStock];
          descriptionController.text = map[AppData.productDescription];
          _selectedCategory = map[AppData.categoryName];

          String images = map[AppData.productImagesURL]
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "");

          fbImages = images.split(", ");
          print(fbImages[0]);

          return new Container(
            margin: new EdgeInsets.only(bottom: 00.0),
            child: new ListView(
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: images == null
                          ? multiImages
                          : new SizedBox(
                              height: 150.0,
                              width: screenSize.width,
                              child: new ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    new Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: new Stack(
                                        alignment: Alignment.topRight,
                                        children: <Widget>[
                                          new Image.network(
                                            fbImages[index],
                                            width: 150.0,
                                            height: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                          new Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new GestureDetector(
                                              onTap: () {
                                                removeImageAt(index);
                                              },
                                              child: new CircleAvatar(
                                                backgroundColor:
                                                    Colors.red[900],
                                                maxRadius: 12.0,
                                                child: new Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 15.0,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                itemCount: fbImages.length,
                              ),
                            ),
                    ),
                    new GestureDetector(
                      onTap: () {
                        //loginWithEmail();
                        fbImages.length == 4
                            ? showInSnackBar(
                                "Sorry Images cannot be more than 4.")
                            : initMultiPickUp();
                      },
                      child: new Container(
                        height: 60.0,
                        margin: new EdgeInsets.only(top: 5.0),
                        child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Container(
                            width: screenSize.width,
                            margin: new EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 2.0),
                            height: 60.0,
                            decoration: new BoxDecoration(
                                color: MyApp.appColors[400],
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(20.0))),
                            child: new Center(
                                child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  ),
                                ),
                                new Text(
                                  "Update Images",
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              items: _productCategories.map((String val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              hint: Text("Please Select a Category"),
                              value: _selectedCategory,
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.black54),
                              onChanged: onChange)),
                    ),
                    new Divider(
                      height: 1.0,
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 12.0, bottom: 5.0),
                      child: new TextFormField(
                        controller: productController,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "Product Name",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
                      child: new TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "Set Price",
                          prefixText: "N ",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 5.0, bottom: 0.0),
                      child: new TextFormField(
                        controller: sizeController,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "Sizes Available",
                          hintText: "Eg. (2, 3, 4,5)",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
                      child: new TextFormField(
                        controller: colorController,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "Colors Available",
                          hintText: "Eg. (red, blue, green, pink)",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 0.0, bottom: 10.0),
                      child: new TextFormField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "No in Stock",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 0.0, bottom: 50.0),
                      child: new TextFormField(
                        controller: descriptionController,
                        maxLines: 4,
                        style: new TextStyle(
                            color: MyApp.appColors[500], fontSize: 18.0),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: "Product Description",
                          labelStyle: new TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  new BorderSide(color: Colors.black54)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return new Container(
            constraints: const BoxConstraints(maxHeight: 500.0),
            child: new Center(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    margin: new EdgeInsets.only(top: 00.0, bottom: 0.0),
                    height: 150.0,
                    width: 150.0,
                    child: new Image.asset(
                        'assets/images/no_internet_access.png')),
                new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Text(
                    "No internet access..",
                    style: new TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
              ],
            )),
          );
        } else {
          return new Center(child: new CircularProgressIndicator());
        }
      },
    );

    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Edit Products",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            onPressed: () {
              //Navigator.pushNamed(context, Base.favoriteScreen);
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new ProductCategories()));
            },
            tooltip: "Categories",
          ),
          new IconButton(
            icon: new Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              addNewProduct();
            },
            tooltip: "Save",
          ),
        ],
      ),
      body: /*streamBuilder*/ futureBuilder,
    );
  }

  Future _getCategories() async {
    showDialog(
      context: context,
      child: progress,
    );

    reference.once().then((snapshot) {
      if (snapshot.value == null) {
        showInSnackBar("No Data Available!!!");
        Navigator.pop(context);
        return;
      }
      Map val = snapshot.value;

      for (int s = 0; s < val.keys.length; s++) {
        val2 = val[val.keys.elementAt(s)];
        _productCategories.add(val2[AppData.categoryName].toString());
      }
      setState(() {
        Navigator.pop(context);
      });
    }).catchError((e) {
      showInSnackBar("Error Occured : $e");
      Navigator.pop(context);
    });
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future addNewProduct() async {
    if (fbImages == null) {
      showInSnackBar("Images cannot be null");
      return;
    }

    if (fbImages.length != 4) {
      showInSnackBar("Images must be four");
      return;
    }

    if (productController.text == "") {
      showInSnackBar("Set Product Name");
      return;
    }

    if (priceController.text == "") {
      showInSnackBar("Set Product Price");
      return;
    }

    if (_selectedCategory == null) {
      showInSnackBar("Set Product Category");
      return;
    }

    if (sizeController.text == "") {
      showInSnackBar("Set Product Sizes");
      return;
    }

    if (colorController.text == "") {
      showInSnackBar("Set Product Colors");
      return;
    }

    if (stockController.text == "") {
      showInSnackBar("Set No In Stock");
      return;
    }

    if (descriptionController.text == "") {
      showInSnackBar("Please Describe Product");
      return;
    }

    showDialog(
      context: context,
      child: progress1,
    );

    //String refKey = productRef.push().key;
    await uploadImages(refKey: widget.productKey);

    productRef.child(widget.productKey).update({
      AppData.productImagesURL: filesURL.toString(),
      AppData.productName: productController.text,
      AppData.productPrice: priceController.text,
      AppData.categoryName: _selectedCategory,
      AppData.productSizesAvailable: sizeController.text,
      AppData.productColorsAvailable: colorController.text,
      AppData.productNoInStock: stockController.text,
      AppData.productDescription: descriptionController.text,
      AppData.keyID: widget.productKey,
    }).catchError((e) {
      showInSnackBar("Error Occured : $e");
      Navigator.pop(context);
    });

    setState(() {
      //resetEverything();
      Navigator.pop(context);
      showInSnackBar("Item Updated Successfully");
    });
  }

  void onChange(String value) {
    setState(() {
      _selectedCategory = value;
    });
  }

  Future uploadImages({String refKey}) async {
    //List<String> url = new List();
    for (int s = 0; s < fbImages.length; s++) {
      if (!fbImages[s].toString().contains("https")) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child(AppData.productsDB)
            .child(refKey)
            .child(refKey + "$s.jpg");
        StorageUploadTask uploadTask =
            storageReference.put(new File(fbImages[s]));
        Uri downloadUrl = (await uploadTask.future).downloadUrl;
        filesURL.add(downloadUrl.toString());
      } else {
        filesURL.add(fbImages[s]);
      }
    }
  }

  void removeImageAt(int index) {
    fbImages.removeAt(index);
    setState(() {});
  }
}
