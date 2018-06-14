import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/models/fbconn.dart';

class SupportAccountSearch extends StatefulWidget {
  final String orderBy;
  final String value;

  SupportAccountSearch({this.orderBy, this.value});

  @override
  _SupportOrdersState createState() => new _SupportOrdersState();
}

class _SupportOrdersState extends State<SupportAccountSearch> {
  //Base messageModel = new Base.messages();
  double price;

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
          .child(AppData.userDB)
          .orderByChild(widget.orderBy)
          .equalTo(widget.value)
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

          FbConn fbconn = new FbConn(map);

          int length = map == null ? 0 : map.keys.length;

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
                          left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Container(
                            height: 60.0,
                            width: 60.0,
                            decoration: new BoxDecoration(
                              //color: color,
                              image: new DecorationImage(
                                  image: fbconn.getProfileImgAsList()[index] ==
                                              "" ||
                                          fbconn.getProfileImgAsList()[index] ==
                                              null
                                      ? new AssetImage(
                                          "assets/images/avatar.png")
                                      : new NetworkImage(
                                          fbconn.getProfileImgAsList()[index])),
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                          ),
                          new Expanded(
                            child: new Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(fbconn.getFullNameAsList()[index]),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                    fbconn.getEmailAsList()[index].toString(),
                                    style: const TextStyle(
                                      color: const Color(0xFF8E8E93),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                    fbconn.getPhoneAsList()[index],
                                    style: TextStyle(
                                      color: const Color(0xFF8E8E93),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                    fbconn.getPasswordAsList()[index],
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
                          new Expanded(
                            child: new Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Container(
                                    width: 90.0,
                                    height: 30.0,
                                    decoration: new BoxDecoration(
                                        color: Colors.pink[900],
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(6.0))),
                                    child: new Center(
                                        child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        new Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: new Icon(
                                            Icons.arrow_forward,
                                            size: 18.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        new Text(
                                          "Send Info",
                                          style: new TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )),
                                  ),
                                  new Padding(
                                      padding: new EdgeInsets.only(
                                          bottom: 5.0, top: 5.0)),
                                  new Container(
                                    width: 90.0,
                                    height: 30.0,
                                    decoration: new BoxDecoration(
                                        color: Colors.pink[900],
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(6.0))),
                                    child: new Center(
                                        child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        new Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: new Icon(
                                            Icons.settings_power,
                                            size: 18.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        new Text(
                                          "Login",
                                          style: new TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )),
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
                return new Container(
                  margin:
                      new EdgeInsets.only(left: 3.0, right: 3.0, bottom: 2.0),
                  color: Colors.white,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      child: new Image.asset('assets/images/avatar.png')),
                  new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Text(
                      "No User Found....",
                      style: new TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ),
                ],
              )),
            );
          } else {
            return new Column(
              children: <Widget>[
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
            "Account Search",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: streamBuilder,
    );
  }
}
