import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/base.dart';
import 'package:girlies/models/fbconn.dart';

class GirliesSupportOrderHistory extends StatefulWidget {
  @override
  _GirliesOrderState createState() => new _GirliesOrderState();
}

class _GirliesOrderState extends State<GirliesSupportOrderHistory> {
  Base orderModel = new Base.products();
  BuildContext context;
  FbConn fbConn;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  var listDialog = new SimpleDialog(
    //title: const Text('Select assignment'),
    children: <Widget>[
      new SimpleDialogOption(
        onPressed: () {},
        child: const Text('Copy'),
      ),
      new Divider(),
      new SimpleDialogOption(
        onPressed: () {},
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

  listAlertDialog() {
    showDialog(context: context, child: listDialog);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size;
    var streamBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.orderHistoryDB)
          .child(AppData.currentUserID)
          .orderByValue()
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FbConn fbconn = new FbConn(map);
          int length = map == null ? 0 : map.keys.length;

          final firstList = new SizedBox(
            height: screenSize.height - 169,
            child: new ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: length,
              itemBuilder: (context, index) {
                final row = new GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: new SafeArea(
                    top: false,
                    bottom: false,
                    child: new Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
                      child: new Row(
                        children: <Widget>[
                          new GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(new PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return new Material(
                                      color: Colors.black38,
                                      child: new Container(
                                        padding: const EdgeInsets.all(30.0),
                                        child: new GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: new Hero(
                                            child: new Image.network(
                                              fbconn
                                                  .getDefaultIMGAsList()[index],
                                              width: 300.0,
                                              height: 300.0,
                                              alignment: Alignment.center,
                                              fit: BoxFit.contain,
                                            ),
                                            tag: fbconn
                                                .getProductNameAsList()[index],
                                          ),
                                        ),
                                      ),
                                    );
                                  }));
                            },
                            child: new Hero(
                              tag: fbconn.getProductNameAsList()[index],
                              child: new Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: new BoxDecoration(
                                  //color: color,
                                  image: new DecorationImage(
                                      image: new NetworkImage(
                                          fbconn.getDefaultIMGAsList()[index])),
                                  borderRadius: new BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          new Expanded(
                            child: new Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                      fbconn.getProductNameAsList()[index]),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                    "N" + fbconn.getProductPriceAsList()[index],
                                    style: const TextStyle(
                                      color: const Color(0xFF8E8E93),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: new Icon(
                              CupertinoIcons.minus_circled,
                              color: MyApp.appColors[600],
                              semanticLabel: 'Substract',
                            ),
                            onPressed: () {
                              /*removeQuantity(fbconn.getKeyIDasList()[index],
                                  fbconn.getItemQuantityAsList()[index]);*/
                            },
                          ),
                          new Text(
                            fbconn.getItemQuantityAsList()[index].toString(),
                            style: const TextStyle(
                              color: const Color(0xFF8E8E93),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          new CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: new Icon(
                              CupertinoIcons.plus_circled,
                              color: MyApp.appColors[600],
                              semanticLabel: 'Add',
                            ),
                            onPressed: () {
                              /*addQuantity(fbconn.getKeyIDasList()[index],
                                  fbconn.getItemQuantityAsList()[index]);*/
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                return new Container(
                  margin:
                      new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      row,
                      new Container(
                        height: 1.0,
                        color: Colors.black12.withAlpha(10),
                      ),
                    ],
                  ),
                );
              },
            ),
          );

          if (map == null) {
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
                      child: new Image.asset('assets/images/empty.png')),
                  new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Text(
                      "You have no order history...",
                      style: new TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ),
                ],
              )),
            );
          } else {
            return firstList;
          }
        } else {
          return new Center(
              child: new Center(child: new CircularProgressIndicator()));
        }
      },
    );

    return Scaffold(
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Support Order History",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: streamBuilder,
    );
  }
}
