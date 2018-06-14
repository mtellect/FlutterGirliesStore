import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/app/screens/payment.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/fbconn.dart';

class GirliesCart extends StatefulWidget {
  @override
  _GirliesCartState createState() => new _GirliesCartState();
}

class _GirliesCartState extends State<GirliesCart> {
  BuildContext context;
  var refreshMenuKey = GlobalKey<RefreshIndicatorState>();
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
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
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

  void addQuantity(String keyIDasList, int itemQuantityAsList) {
    FirebaseDatabase.instance
        .reference()
        .child(AppData.cartDB)
        .child(AppData.currentUserID)
        .child(keyIDasList)
        .update({AppData.itemQuantity: itemQuantityAsList + 1});
  }

  void removeQuantity(String keyIDasList, int itemQuantityAsList) {
    if (itemQuantityAsList == 1) return;
    FirebaseDatabase.instance
        .reference()
        .child(AppData.cartDB)
        .child(AppData.currentUserID)
        .child(keyIDasList)
        .update({AppData.itemQuantity: itemQuantityAsList - 1});
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size;
    var streamBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.cartDB)
          .child(AppData.currentUserID)
          .orderByValue()
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FbConn fbconn = new FbConn(map);
          int length = map == null ? 0 : map.keys.length;

          final cartSummary = new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Container(
              margin: new EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      "ITEMS (${length == 0 ? "0" : fbconn.getDataSize( )
                          .toString( )})",
                      style: new TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w700),
                    ),
                    new Text(
                      "TOTAL : N${length == 0 ? "0" : fbconn
                          .getTotalProductPrice().toString( )}",
                      style: new TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w700),
                    ),
                  ]),
            ),
          );

          final firstList = new Flexible(
            child: new ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: length,
              itemBuilder: (context, index) {
                final buttons = new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new GestureDetector(
                        onTap: () {
                          fbconn.removeFromCart(index);
                          /* showInSnackBar(fbconn.getProductNameAsList()[index] +
                              " has been removed");
                          setState(() {});*/
                        },
                        child: new Container(
                          width: 120.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(5.0))),
                          child: new Center(
                              child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: new Icon(
                                  Icons.remove_shopping_cart,
                                  size: 18.0,
                                  color: MyApp.appColors[600],
                                ),
                              ),
                              new Text(
                                "REMOVE",
                                style: new TextStyle(
                                    color: MyApp.appColors[600],
                                    fontSize: 10.0),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                    new Container(
                      height: 30.0,
                      width: 1.0,
                      color: Colors.black12,
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new GestureDetector(
                        onTap: () {
                          fbconn.addIsFavoriteIndex(true, index);
                          /* showInSnackBar(fbconn.getProductNameAsList()[index] +
                              " has been added to your favorites");
                          setState(() {});*/
                        },
                        child: new Container(
                          width: 120.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(5.0))),
                          child: new Center(
                              child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: new Icon(
                                  Icons.favorite_border,
                                  size: 18.0,
                                  color: MyApp.appColors[600],
                                ),
                              ),
                              new Text(
                                "ADD TO FAVORITES",
                                style: new TextStyle(
                                    color: MyApp.appColors[600],
                                    fontSize: 10.0),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                  ],
                );

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
                              removeQuantity(fbconn.getKeyIDasList()[index],
                                  fbconn.getItemQuantityAsList()[index]);
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
                              addQuantity(fbconn.getKeyIDasList()[index],
                                  fbconn.getItemQuantityAsList()[index]);
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
                      buttons
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
                      child: new Image.asset('assets/images/cart_empty.png')),
                  new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Text(
                      "You have no item in your cart....",
                      style: new TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ),
                ],
              )),
            );
          } else {
            return new Column(
              children: <Widget>[
                cartSummary,
                firstList,
                new Container(
                  height: 50.0,
                  color: Colors.white,
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (BuildContext context) => new OrderSummary(
                                  cartTotal:
                                      fbconn.getTotalProductPrice().toString(),
                                  totalItems: fbconn.getDataSize().toString(),
                                )));
                      },
                      child: new Container(
                        width: screenSize.width,
                        margin: new EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 2.0),
                        height: 50.0,
                        decoration: new BoxDecoration(
                            color: MyApp.appColors[600],
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(5.0))),
                        child: new Center(
                            child: new Text(
                          "PROCEED TO PAYMENT",
                          style: new TextStyle(
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        } else {
          return new Center(
              child: new Center(child: new CircularProgressIndicator()));
        }
      },
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Cart",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: streamBuilder,
    );
  }
}
