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
import 'package:girlies/support/screens/add_categories.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => new _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
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

  List images;
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

  @override
  void initState() {
    // TODO: implement initState
    images = null;
    _getCategories();
    super.initState();
  }

  initMultiPickUp() async {
    int imageLength =
        images == null ? 0 : images.length == 0 ? images.length : images.length;
    List resultList;
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
      //images = resultList;
      if (images == null) {
        images = new List.from(resultList, growable: true);
      } else {
        for (int s = 0; s < resultList.length; s++) {
          images.add(resultList[s].toString());
        }
//        showInSnackBar(resultList.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Add Products",
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
      body: new Container(
        margin: new EdgeInsets.only(bottom: 00.0),
        child: new ListView(
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: images == null || images.length == 0
                      ? new Container()
                      : new SizedBox(
                          height: 150.0,
                          width: screenSize.width,
                          child: new ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) =>
                                new Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: new Stack(
                                    alignment: Alignment.topRight,
                                    children: <Widget>[
                                      new Image.file(
                                        new File(images[index]),
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
                                            backgroundColor: Colors.red[900],
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
                            itemCount: images.length,
                          ),
                        ),
                ),
                new GestureDetector(
                  onTap: () {
                    //loginWithEmail();
                    images == null
                        ? initMultiPickUp()
                        : images.length == 4
                            ? showInSnackBar(
                                "Sorry Images cannot be more than 4.")
                            : initMultiPickUp();

                    //initMultiPickUp();
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
                              "Add Images",
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
                      labelStyle:
                          new TextStyle(fontSize: 20.0, color: Colors.black54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: new BorderSide(color: Colors.black54)),
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
                      labelStyle:
                          new TextStyle(fontSize: 20.0, color: Colors.black54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: new BorderSide(color: Colors.black54)),
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
                      labelStyle:
                          new TextStyle(fontSize: 20.0, color: Colors.black54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: new BorderSide(color: Colors.black54)),
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
                      labelStyle:
                          new TextStyle(fontSize: 20.0, color: Colors.black54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: new BorderSide(color: Colors.black54)),
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
                      labelStyle:
                          new TextStyle(fontSize: 20.0, color: Colors.black54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: new BorderSide(color: Colors.black54)),
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
                      labelStyle:
                          new TextStyle(fontSize: 20.0, color: Colors.black54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: new BorderSide(color: Colors.black54)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
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
    if (imageOne == null) {
      showInSnackBar("Set Image One");
      return;
    }

    if (imageTwo == null) {
      showInSnackBar("Set Image Two");
      return;
    }

    if (imageThree == null) {
      showInSnackBar("Set Image Three");
      return;
    }

    if (imageFour == null) {
      showInSnackBar("Set Image Four");
      return;
    }

    //showInSnackBar(productController.text);

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

    //TODO
    //Map c = colorController.text.split(",").asMap();

    files.add(imageOne);
    files.add(imageTwo);
    files.add(imageThree);
    files.add(imageFour);
    //showInSnackBar(files[3].toString());

    showDialog(
      context: context,
      child: progress1,
    );

    String refKey = productRef.push().key;
    await uploadImages(refKey: refKey);

    productRef.child(refKey).set({
      AppData.productImagesURL: filesURL.toString(),
      AppData.productName: productController.text,
      AppData.productPrice: priceController.text,
      AppData.categoryName: _selectedCategory,
      AppData.productSizesAvailable: sizeController.text,
      AppData.productColorsAvailable: colorController.text,
      AppData.productNoInStock: stockController.text,
      AppData.productDescription: descriptionController.text,
      AppData.keyID: refKey,
    }).catchError((e) {
      showInSnackBar("Error Occured : $e");
      Navigator.pop(context);
    });

    setState(() {
      resetEverything();
      Navigator.pop(context);
      showInSnackBar("Item added Successfully");
    });
  }

  void onChange(String value) {
    setState(() {
      _selectedCategory = value;
    });
  }

  Future uploadImages({String refKey}) async {
    for (int s = 0; s < images.length; s++) {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child(AppData.productsDB)
          .child(refKey)
          .child(refKey + "$s.jpg");
      StorageUploadTask uploadTask = storageReference.put(images[s]);
      Uri downloadUrl = (await uploadTask.future).downloadUrl;
      filesURL.add(downloadUrl.toString());
    }
  }

  void resetEverything() {
    _selectedCategory = null;
    images = null;
    files.clear();
    filesURL.clear();
    productController.clear();
    priceController.clear();
    sizeController.clear();
    colorController.clear();
    stockController.clear();
    descriptionController.clear();
  }

  void removeImageAt(int index) {
    images.removeAt(index);
    setState(() {});
  }
}
