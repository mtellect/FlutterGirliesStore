import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/models/base.dart';
import 'package:girlies/models/fbconn.dart';
import 'package:girlies/models/ref_time.dart';
import 'package:girlies/support/screens/support_chat.dart';

class ChatScreen extends StatefulWidget {
  final List<Base> messages;

  ChatScreen({this.messages});

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  FbConn fbConn;
  FbConn fbConnMessages;
  TimeAgo timeAgoo = new TimeAgo();

  StreamSubscription<Event> _messageSubscription;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;

  String userid;
  String fullName;
  String email;
  String phone;
  String profileImgUrl;
  bool isLoggedIn;
  Timer timer;

  List<String> userIDS = new List();

  @override
  void initState() {
    _getUserMessages();
    timer = new Timer.periodic(new Duration(seconds: 1), (_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  Future _getUserMessages() async {
    final messageRef =
        FirebaseDatabase.instance.reference().child(AppData.conversationsDB);

    _messageSubscription = messageRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        fbConn = null;
        setState(() {});
        return;
      }
      Map valFav = event.snapshot.value;
      fbConn = new FbConn(valFav);
      print(fbConn.getDataSize());
      print(fbConn.getMessageSenderNameAsList()[0]);
//
//      //Map map1 = valFav[valFav.keys.elementAt(1)];
//      //Map map2 = map1[map1.keys.elementAt(0)];
//      //showInSnackBar(map1.keys.length.toString());
//
//      valFav.keys.forEach((value) {
//        //showInSnackBar("$value");
//        userIDS.add(value);
//        //fbConn.getUserInfo(value);
//      });
//
//      List<Map> info = new List();
//      for (int s = 0; s < userIDS.length; s++) {
//        //getUserInfo(userIDS[s])[0];
//        //showInSnackBar(userIDS[s]);
//        //info = getUserInfo(userid[s], s);
//        //showInSnackBar(getUserInfo(userIDS[s]).toString());
//        FirebaseDatabase.instance
//            .reference()
//            .child(AppData.userDB)
//            .child(userIDS[s])
//            .once()
//            .then((snapshot) {
//          Map value = snapshot.value;
//          /* user[AppData.profileImgURL] = value[AppData.profileImgURL];
//          user[AppData.fullName] = value[AppData.fullName];
//          map.addAll(user.values);*/
//          showInSnackBar(value[AppData.fullName]);
//        });
//      }
      //showInSnackBar(fbConn.getMessageSenderIDasList()[0]);

      //showInSnackBar(map2.toString());
      //showInSnackBar(map2.keys.elementAt(0).toString());
//      for (int s = 0; s < valFav.keys.length; s++) {
//        valFav.keys.forEach((value) {
//          showInSnackBar("$value");
//        });
//      }
      //showInSnackBar(fbConn.getKeyIDasList().toString());

//      Map map = valFav[valFav.keys.elementAt(1)];
//      fbConnMessages = new FbConn(map);
      setState(() {});
    });
  }

  Future<Map> _getSupportMessages() async {
    Map dataSnapshot;

    FirebaseDatabase.instance
        .reference()
        .child(AppData.messagesDB)
        .child("jQLzFNybEYYuuuakTxp6KN54IJA3")
        .onValue
        .listen((event) {
      dataSnapshot = event.snapshot.value;
    });
    return dataSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    // TODO: implement build
    var futureBuilder = new FutureBuilder(
      future: _getSupportMessages(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('Press button to start');
          case ConnectionState.waiting:
            return new Text('Awaiting result...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return new Text('Result: ${snapshot.data["messageSenderEmail"]}');
        }
      },
    );

    var streamBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.conversationsDB)
          .orderByValue()
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FbConn fbconn = new FbConn(map);
          int length = map.keys.length;

          final firstList = new ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: length,
            itemBuilder: (context, index) {
              final row = new GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPress: listAlertDialog,
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new GirliesChats(
                            senderUID: fbconn.getMessageSenderIDasList()[
                                fbconn.getDataSize() - index - 1],
                            senderImage: fbconn.getSenderImageAsList()[
                                fbconn.getDataSize() - index - 1],
                            senderEmail: fbconn.getSenderEmailAsList()[
                                fbconn.getDataSize() - index - 1],
                            senderName: fbconn.getMessageSenderNameAsList()[
                                fbconn.getDataSize() - index - 1],
                            messageID: fbconn.getMessageIDasList()[
                                fbconn.getDataSize() - index - 1],
                            messageKeyID: fbconn.getMessageKeyIDasList()[
                                fbconn.getDataSize() - index - 1],
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
                        fbconn.getSenderImageAsList()[
                                    fbconn.getDataSize() - index - 1] ==
                                ""
                            ? new Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    image: new DecorationImage(
                                        image: new AssetImage(
                                            "assets/images/avatar.png"))),
                                /*child: new Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),*/
                              )
                            : new GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      new PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder:
                                              (BuildContext context, _, __) {
                                            return new Material(
                                              color: Colors.black38,
                                              child: new Container(
                                                padding:
                                                    const EdgeInsets.all(30.0),
                                                child: new GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: new Hero(
                                                    child: new Image.network(
                                                      fbconn.getSenderImageAsList()[
                                                          length - index - 1],
                                                      width: 300.0,
                                                      height: 300.0,
                                                      alignment:
                                                          Alignment.center,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    tag: fbconn
                                                            .getMessageSenderNameAsList()[
                                                        length - index - 1],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }));
                                },
                                child: new Hero(
                                  tag: fbconn.getMessageSenderNameAsList()[
                                      length - index - 1],
                                  child: new Container(
                                    height: 60.0,
                                    width: 60.0,
                                    decoration: new BoxDecoration(
                                      //color: color,

                                      image: new DecorationImage(
                                          image: new NetworkImage(
                                              fbconn.getSenderImageAsList()[
                                                  length - index - 1])),
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                        fbconn.getMessageSenderNameAsList()[
                                            length - index - 1]),
                                    const Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0)),
                                    new Text(
                                      timeAgoo.timeUpdater(new DateTime
                                              .fromMillisecondsSinceEpoch(
                                          fbconn.getMessageTimeAsList()[
                                              length - index - 1])),
                                      style: new TextStyle(
                                        color: Colors.pink[400],
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                                /*const Padding(
                                    padding: const EdgeInsets.only(top: 5.0)),
                                new Text(
                                  timeAgoo.timeUpdater(
                                      new DateTime.fromMillisecondsSinceEpoch(
                                          fbconn.getMessageTimeAsList()[
                                              length - index - 1])),
                                  style: new TextStyle(
                                    color: Colors.pink[400],
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),*/
                                const Padding(
                                    padding: const EdgeInsets.only(top: 5.0)),
                                fbconn.getMessageRead()[length - index - 1] ==
                                        false
                                    ? new Text(
                                        fbconn.getMessageTextAsList()[
                                            length - index - 1],
                                        maxLines: 1,
                                        style: new TextStyle(
                                            color: Colors.pink[900],
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400))
                                    : new Text(
                                        fbconn.getMessageTextAsList()[
                                            length - index - 1],
                                        maxLines: 1,
                                        style: new TextStyle(
                                          color: new Color(0xFF8E8E93),
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w300,
                                        )),
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
                margin: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
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
          );

          final secondList = new ListView.builder(
            itemCount: length,
            itemBuilder: (context, index) => new Column(
                  children: <Widget>[
                    new Divider(
                      height: 2.0,
                    ),
                    new ListTile(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (BuildContext context) => new GirliesChats(
                                  senderUID: fbconn.getMessageSenderIDasList()[
                                      fbconn.getDataSize() - index - 1],
                                  senderImage: fbconn.getSenderImageAsList()[
                                      fbconn.getDataSize() - index - 1],
                                  senderEmail: fbconn.getSenderEmailAsList()[
                                      fbconn.getDataSize() - index - 1],
                                  senderName:
                                      fbconn.getMessageSenderNameAsList()[
                                          fbconn.getDataSize() - index - 1],
                                  messageID: fbconn.getMessageIDasList()[
                                      fbconn.getDataSize() - index - 1],
                                  messageKeyID: fbconn.getMessageKeyIDasList()[
                                      fbconn.getDataSize() - index - 1],
                                )));
                      },
                      leading: fbconn.getSenderImageAsList()[
                                  fbconn.getDataSize() - index - 1] ==
                              ""
                          ? new CircleAvatar(
                              foregroundColor: Theme.of(context).primaryColor,
                              backgroundColor: Colors.pink[900],
                              child: new Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            )
                          : new CircleAvatar(
                              foregroundColor: Theme.of(context).primaryColor,
                              backgroundColor: Colors.black,
                              backgroundImage: new NetworkImage(
                                fbconn.getSenderImageAsList()[
                                    fbconn.getDataSize() - index - 1],
                              ),
                            ),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                              fbconn.getMessageSenderNameAsList()[
                                  fbconn.getDataSize() - index - 1],
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                          new Text(
                              timeAgoo.timeUpdater(
                                  new DateTime.fromMillisecondsSinceEpoch(
                                      fbconn.getMessageTimeAsList()[
                                          fbconn.getDataSize() - index - 1])),
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 14.0)),
                        ],
                      ),
                      subtitle: new Container(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: fbconn.getMessageRead()[index] == false
                            ? new Text(fbconn.getMessageTextAsList()[index],
                                maxLines: 1,
                                style: new TextStyle(
                                    color: Colors.pink[900],
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))
                            : new Text(
                                fbconn.getMessageTextAsList()[
                                    fbconn.getDataSize() - index - 1],
                                maxLines: 1,
                                style: new TextStyle(
                                    color: Colors.grey, fontSize: 15.0)),
                      ),
                    )
                  ],
                ),
          );

          return firstList;
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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: streamBuilder,
    );
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
}
