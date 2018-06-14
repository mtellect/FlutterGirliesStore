import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/app/progress.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/fbconn.dart';
import 'package:girlies/support/screens/edit_prodcuts.dart';

class BoutiqueStore extends StatefulWidget {
  @override
  _BoutiqueStoreState createState() => new _BoutiqueStoreState();
}

class _BoutiqueStoreState extends State<BoutiqueStore> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Please wait...',
  );

  listAlertDialog(String productKey) {
    var listDialog = new SimpleDialog(
      //title: const Text('Select assignment'),
      children: <Widget>[
        new SimpleDialogOption(
          onPressed: () {},
          child: const Text('Copy'),
        ),
        new Divider(),
        new SimpleDialogOption(
          onPressed: () {
            //Navigator.of(context).pop();
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new EditProducts(
                      productKey: productKey,
                    )));
          },
          child: const Text('Edit'),
        ),
        new Divider(),
        new SimpleDialogOption(
          onPressed: () {},
          child: const Text('Hide'),
        ),
        new Divider(),
        new SimpleDialogOption(
          onPressed: () {},
          child: const Text('Delete'),
        ),
      ],
    );

    showDialog(context: context, child: listDialog);
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var streamBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.productsDB)
          .orderByValue()
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FbConn fbConn = new FbConn(map);
          int length = map.keys.length;

          final storeItems = new GridView.builder(
            itemCount: length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              final buttons = new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Container(
                    height: 20.0,
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0))),
                    child: new Center(
                        child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: new Icon(
                            Icons.delete_forever,
                            size: 15.0,
                            color: MyApp.appColors[600],
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: new Text(
                            "DELETE",
                            style: new TextStyle(
                                color: MyApp.appColors[600], fontSize: 10.0),
                          ),
                        ),
                      ],
                    )),
                  ),
                  new Container(
                    height: 20.0,
                    width: 1.0,
                    color: Colors.black12,
                    margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                  ),
                  new Container(
                    height: 20.0,
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0))),
                    child: new Center(
                        child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: new Icon(
                            Icons.edit,
                            size: 15.0,
                            color: MyApp.appColors[600],
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: new Text(
                            "EDIT",
                            style: new TextStyle(
                                color: MyApp.appColors[600], fontSize: 10.0),
                          ),
                        ),
                      ],
                    )),
                  ),
                ],
              );
              return new GestureDetector(
                onLongPress: () {
                  listAlertDialog(fbConn.getKeyIDasList()[index]);
                },
                child: new Card(
                  child: new GridTile(
                      child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Image.network(
                          fbConn.getDefaultIMGAsList()[index],
                          height: 100.0,
                        ),
                      ),
                      new Align(
                        alignment: Alignment.center,
                        child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Text(
                            "N" + fbConn.getProductPriceAsList()[index],
                          ),
                        ),
                      ),
                      //buttons
                    ],
                  ) //just for testing, will fill with image later
                      ),
                ),
              );
            },
          );

          return storeItems;
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
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Boutique",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: streamBuilder,
    );
  }
}
