import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/base.dart';
import 'package:girlies/models/fbconn.dart';
import 'package:girlies/models/ref_time.dart';
import 'package:girlies/support/screens/requests.dart';

class SupportOrders extends StatefulWidget {
  final List<Base> orders;

  SupportOrders({this.orders});

  @override
  _SupportOrdersState createState() => new _SupportOrdersState();
}

class _SupportOrdersState extends State<SupportOrders> {
  //Base messageModel = new Base.messages();
  double price;
  TimeAgo timeAgoo = new TimeAgo();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var streamBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.notifyAdminOrderDB)
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
                      "TOTAL : N ${length == 0 ? "0" : fbconn
                          .getAdminTotalProductPrice().toString()}",
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
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new GirliesRequests(
                              requestKey: fbconn.getKeyIDasList()[index],
                            )));
                  },
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
                                              fbconn.getOrderSenderImgAsList()[
                                                  index],
                                              width: 300.0,
                                              height: 300.0,
                                              alignment: Alignment.center,
                                              fit: BoxFit.contain,
                                            ),
                                            tag: fbconn
                                                    .getOrderSenderNameAsList()[
                                                index],
                                          ),
                                        ),
                                      ),
                                    );
                                  }));
                            },
                            child: new Hero(
                              tag: fbconn.getOrderSenderNameAsList()[index],
                              child: new Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: new BoxDecoration(
                                  //color: color,
                                  image: new DecorationImage(
                                      image: new NetworkImage(fbconn
                                          .getOrderSenderImgAsList()[index])),
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
                                      fbconn.getOrderSenderNameAsList()[index]),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                    timeAgoo.timeUpdater(new DateTime
                                            .fromMillisecondsSinceEpoch(
                                        fbconn.getOrderTimeAsList()[index])),
                                    style: const TextStyle(
                                      color: const Color(0xFF8E8E93),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                    "Order Amount : N" +
                                        fbconn
                                            .getOrderAmountAsList()[index]
                                            .toString(),
                                    style: TextStyle(
                                      color: MyApp.appColors[400],
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                    "No of Items : " +
                                        fbconn.getOrderNoAsList()[index] +
                                        " (items)",
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
                                Icons.forward_5,
                                size: 18.0,
                                color: MyApp.appColors[600],
                              ),
                            ),
                            new Text(
                              "RE-FORWARD",
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
                                Icons.cancel,
                                size: 18.0,
                                color: MyApp.appColors[600],
                              ),
                            ),
                            new Text(
                              "CANCEL",
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
                      buttons,
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
                      "You have no support order request....",
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
            "Order Requests",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: streamBuilder,
    );
  }
}
