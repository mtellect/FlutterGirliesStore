import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/base.dart';
import 'package:girlies/models/fbconn.dart';

class GirliesOrderItem extends StatefulWidget {
  final String requestKey;
  GirliesOrderItem({this.requestKey});
  @override
  _GirliesRequestsState createState() => new _GirliesRequestsState();
}

class _GirliesRequestsState extends State<GirliesOrderItem> {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    this.context = context;

    var streamBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.adminOrdersDB)
          .child(widget.requestKey)
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
                      "This order request is empty....",
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
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Order Request",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: streamBuilder,
    );
  }
}

class _OrderLists extends StatefulWidget {
  final List<Base> orders;

  _OrderLists({this.orders});

  @override
  _OrderListsState createState() {
    return new _OrderListsState();
  }
}

class _OrderListsState extends State<_OrderLists> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new SizedBox(
      height: screenSize.height - 135,
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.orders.length,
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
                                        widget.orders[index].productImgURL,
                                        width: 300.0,
                                        height: 300.0,
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain,
                                      ),
                                      tag: widget.orders[index].productTitle,
                                    ),
                                  ),
                                ),
                              );
                            }));
                      },
                      child: new Hero(
                        tag: widget.orders[index].productTitle,
                        child: new Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: new BoxDecoration(
                            //color: color,
                            image: new DecorationImage(
                                image: new NetworkImage(
                                    widget.orders[index].productImgURL)),
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(widget.orders[index].productTitle),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                            new Text(
                              "N" +
                                  widget.orders[index].productPrice.toString(),
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
                      onPressed: null,
                    ),
                    new Text(
                      widget.orders[index].itemQuantity.toString(),
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
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ),
          );
          final buttons = new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Container(
                  width: 120.0,
                  height: 40.0,
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
                          Icons.remove_shopping_cart,
                          size: 18.0,
                          color: MyApp.appColors[600],
                        ),
                      ),
                      new Text(
                        "REMOVE",
                        style: new TextStyle(
                            color: MyApp.appColors[600], fontSize: 10.0),
                      ),
                    ],
                  )),
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
                child: new Container(
                  width: 120.0,
                  height: 40.0,
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
                          Icons.shopping_cart,
                          size: 18.0,
                          color: MyApp.appColors[600],
                        ),
                      ),
                      new Text(
                        "ADD TO CART",
                        style: new TextStyle(
                            color: MyApp.appColors[600], fontSize: 10.0),
                      ),
                    ],
                  )),
                ),
              ),
            ],
          );

          return new Container(
            margin: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                row,
              ],
            ),
          );
        },
      ),
    );
  }
}
