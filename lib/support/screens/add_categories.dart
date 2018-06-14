import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/app/progress.dart';
import 'package:girlies/main.dart';
import 'package:image_picker/image_picker.dart';

class ProductCategories extends StatefulWidget {
  @override
  _GirliesBoutiqueState createState() => new _GirliesBoutiqueState();
}

class _GirliesBoutiqueState extends State<ProductCategories> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _canAddCategory = false;
  File catergoryImage;
  bool isAdding = false;
  BuildContext context;
  static DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  static final reference = dbRef.child(AppData.categoriesDB);
  String editText;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reference.keepSynced(true);
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Saving....',
  );

  void showInSnackBar(String value) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new GestureDetector(
          onTap: () {},
          child: new Text(
            "Categories",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildCatergoryAdder(),
            ),
            new Flexible(
                child: new FirebaseAnimatedList(
              defaultChild: new Center(
                child: new CircularProgressIndicator(),
              ),
              query: reference,
              padding: const EdgeInsets.all(8.0),
              reverse: false,
              sort: (a, b) {
                return b.key.compareTo(a.key);
              },
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation animation, int index) {
                return new Container(
                  height: 60.0,
                  color: Colors.white,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Container(
                            child: new CircleAvatar(
                              backgroundImage: new NetworkImage(
                                  snapshot.value[AppData.categoryImgURL]),
                            ),
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(left: 10.0)),
                        new Flexible(
                          fit: FlexFit.tight,
                          child: new Text(snapshot.value[AppData.categoryName]),
                        ),
                        new Container(
                          child: new Row(
                            children: <Widget>[
                              new IconButton(
                                  icon: new Icon(
                                    Icons.edit,
                                    size: 20.0,
                                    color: MyApp.appColors,
                                  ),
                                  onPressed: () {
                                    _editCategory(snapshot: snapshot);
                                  }),
                              new Container(
                                height: 30.0,
                                width: 1.0,
                                color: Colors.black12,
                                margin: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                              ),
                              new IconButton(
                                  icon: new Icon(
                                    Icons.delete_forever,
                                    size: 20.0,
                                    color: MyApp.appColors,
                                  ),
                                  onPressed: () {
                                    _removeCategory(
                                        refKey: snapshot.value[AppData.keyID]);
                                  })
                            ],
                          ),
                        )
                      ]),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCatergoryAdder() {
    return new IconTheme(
        data: new IconThemeData(
          color: _canAddCategory
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new InkWell(
                onTap: () {
                  setCategoryIMG();
                },
                child: new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 4.0),
                    child: catergoryImage == null
                        ? new CircleAvatar(
                            child: new Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 15.0,
                            ),
                          )
                        : new CircleAvatar(
                            backgroundImage: new FileImage(catergoryImage),
                          )),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      if (catergoryImage != null)
                        _canAddCategory = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration: new InputDecoration.collapsed(
                    hintText: "Enter New Caterory",
                  ),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Add"),
      onPressed: _canAddCategory
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.add_circle_outline),
      onPressed: _canAddCategory
          ? () {
              return _textMessageSubmitted(_textEditingController.text);
            }
          : null,
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    showDialog(
      context: context,
      child: progress,
    );
    _createCategory(categoryName: text);
  }

  Future setCategoryIMG() async {
    File imgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imgFile != null) {
      setState(() {
        catergoryImage = imgFile;
      });
    }
  }

  Future _createCategory({String categoryName}) async {
    String refKey = reference.push().key;
    setState(() {
      isAdding = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(AppData.categoriesDB)
        .child(refKey)
        .child(refKey + ".jpg");
    StorageUploadTask uploadTask = storageReference.put(catergoryImage);
    Uri downloadUrl = (await uploadTask.future).downloadUrl;

    reference.child(refKey).set({
      AppData.categoryImgURL: downloadUrl.toString(),
      AppData.categoryName: categoryName,
      AppData.keyID: refKey,
    });

    setState(() {
      catergoryImage = null;
      _textEditingController.clear();
      isAdding = false;
      Navigator.pop(context);
    });
  }

  Future _removeCategory({String refKey}) async {
    FirebaseStorage.instance
        .ref()
        .child(AppData.productCategories)
        .child(refKey)
        .child(refKey + ".jpg")
        .delete();
    reference.child(refKey).remove();

    showInSnackBar('Category has been removed!');
  }

  Future _editCategory({DataSnapshot snapshot}) async {
    setState(() {
      _textEditingController.text = snapshot.value[AppData.categoryName];
    });
  }
}
