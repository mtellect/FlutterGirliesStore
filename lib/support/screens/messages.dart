import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/app/screens/app_chat.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/base.dart';
import 'package:girlies/models/fbconn.dart';

class SupportMessages extends StatefulWidget {
  @override
  _SupportMessagesState createState() => new _SupportMessagesState();
}

class _SupportMessagesState extends State<SupportMessages> {
  Base messageModel = new Base.messages();

  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  FbConn fbConn;

  StreamSubscription<Event> _messageSubscription;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String userid;
  String fullName;
  String email;
  String phone;
  String profileImgUrl;
  bool isLoggedIn;
  String _btnText;
  bool _isSignedIn = false;
  var _scaffoldContext;

  @override
  void initState() {
    super.initState();
    _getUserMessages();
    new Timer.periodic(new Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  Future _getUserMessages() async {
    final messageRef =
        FirebaseDatabase.instance.reference().child(AppData.messagesDB);

    _messageSubscription = await messageRef.once().then((snapshot) {
      if (snapshot.value == null) {
        showInSnackBar("Empty");
        print("empty");
        return;
      }
      Map valFav = snapshot.value;
      FbConn fbConn = new FbConn(valFav);
      showInSnackBar(fbConn.getDataSize().toString());
      print(fbConn.getDataSize().toString());
      //setState(() {});
    });

    /*  _messageSubscription = messageRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        cartCount = 0;
        setState(() {});
        return;
      }
      Map valFav = event.snapshot.value;
      FbConn fbConn = new FbConn(valFav);
      cartCount = fbConn.getDataSize();
      setState(() {});
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: new RefreshIndicator(
        child: new ListView(
          children: <Widget>[
            new _MessageList(
              messages: messageModel.buildDemoMessages(),
            ),
          ],
        ),
        onRefresh: () {},
      ),
    );
  }
}

class _MessageList extends StatefulWidget {
  final List<Base> messages;

  _MessageList({this.messages});

  /* @override
  _MessageListState createState() {
    return new _MessageListState();
  }*/
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class _MessageListState extends State<_MessageList> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new SizedBox(
      height: screenSize.height - 140,
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.messages.length,
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
                                        widget.messages[index].senderImgUrl,
                                        width: 300.0,
                                        height: 300.0,
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain,
                                      ),
                                      tag: widget.messages[index].senderName,
                                    ),
                                  ),
                                ),
                              );
                            }));
                      },
                      child: new Hero(
                        tag: widget.messages[index].senderName,
                        child: new Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: new BoxDecoration(
                            //color: color,
                            image: new DecorationImage(
                                image: new NetworkImage(
                                    widget.messages[index].senderImgUrl)),
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
                            new Text(widget.messages[index].senderName),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                            new Text(
                              widget.messages[index].messageTime,
                              style: const TextStyle(
                                color: const Color(0xFF8E8E93),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                            new Text(
                              widget.messages[index].messageSent,
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
                          Icons.delete_forever,
                          size: 18.0,
                          color: MyApp.appColors[600],
                        ),
                      ),
                      new Text(
                        "DELETE",
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
                child: new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            new GirliesAppChat()));
                  },
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
                            Icons.reply,
                            size: 18.0,
                            color: MyApp.appColors[600],
                          ),
                        ),
                        new Text(
                          "REPLY",
                          style: new TextStyle(
                              color: MyApp.appColors[600], fontSize: 10.0),
                        ),
                      ],
                    )),
                  ),
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
  }
}

class ChatScreenState extends State<_MessageList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => new Column(
            children: <Widget>[
              new Divider(
                height: 10.0,
              ),
              new ListTile(
                leading: new CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      new NetworkImage(widget.messages[index].senderImgUrl),
                ),
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(widget.messages[index].senderName,
                        style: new TextStyle(fontWeight: FontWeight.bold)),
                    new Text(widget.messages[index].messageTime,
                        style:
                            new TextStyle(color: Colors.grey, fontSize: 14.0)),
                  ],
                ),
                subtitle: new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text(widget.messages[index].messageSent,
                      style: new TextStyle(color: Colors.grey, fontSize: 15.0)),
                ),
              )
            ],
          ),
    );
  }
}
