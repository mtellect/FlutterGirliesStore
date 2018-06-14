import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/models/ref_time.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

final googleSignIn = new GoogleSignIn();
//final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
var currentUserEmail;
var _scaffoldContext;

class GirliesChats extends StatefulWidget {
  final String senderUID;
  final String senderName;
  final String senderImage;
  final String senderEmail;
  final String messageID;
  final String messageKeyID;

  GirliesChats(
      {this.senderUID,
      this.senderName,
      this.senderImage,
      this.senderEmail,
      this.messageID,
      this.messageKeyID});

  @override
  _GirliesChatsState createState() => new _GirliesChatsState();
}

class _GirliesChatsState extends State<GirliesChats> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  //DatabaseReference reference;
  BuildContext context;
  String supportUID = "08143733836Girlies";
  String fullName = "Girlies Support";
  String email = "girlies.suport@gmail.com";
  String phone = "08143733836";

  String profileImgUrl =
      "https://www.ngmark.com/merchant/wp-content/uploads/2017/11/customers1-1.jpg";

  @override
  void initState() {
    // TODO: implement initState
    updateMessageSeenRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    this.context = context;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Chat us"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new FirebaseAnimatedList(
                  defaultChild: new Center(
                    child: new CircularProgressIndicator(),
                  ),
                  query: FirebaseDatabase.instance
                      .reference()
                      .child(AppData.messagesDB)
                      .child(widget.messageID),
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  sort: (a, b) {
                    return b.key.compareTo(a.key);
                  },
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation animation, int index) {
                    return new ChatMessage(
                      messageSnapshot: snapshot,
                      animation: animation,
                      userid: supportUID,
                    );
                  },
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              new Builder(builder: (BuildContext context) {
                _scaffoldContext = context;
                return new Container(width: 0.0, height: 0.0);
              })
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  image: new DecorationImage(
                      repeat: ImageRepeat.repeat,
                      image: new Image.asset(
                        "assets/images/ic_launcher.png",
                        scale: 0.9,
                        width: 25.0,
                        height: 25.0,
                      ).image),
                  border: new Border(
                      top: new BorderSide(
                    color: Colors.grey[200],
                  )),
                )
              : new BoxDecoration(
                  color: Colors.grey[100],
                  image: new DecorationImage(
                      repeat: ImageRepeat.repeat,
                      image: new Image.asset(
                        "assets/images/girlies_text_small.png",
                        scale: 0.1,
                        width: 15.0,
                        height: 15.0,
                      ).image),
                  border: new Border(
                      top: new BorderSide(
                    color: Colors.grey[200],
                  )),
                ),
        ));
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      //await _ensureLoggedIn();
                      File imageFile = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      StorageReference storageReference = FirebaseStorage
                          .instance
                          .ref()
                          .child("img_" + timestamp.toString() + ".jpg");
                      StorageUploadTask uploadTask =
                          storageReference.put(imageFile);
                      Uri downloadUrl = (await uploadTask.future).downloadUrl;
                      _sendMessage(
                          messageText: null, imageUrl: downloadUrl.toString());
                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
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

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child(AppData.messagesDB)
        .child(widget.messageID);

    DateTime currentTime = new DateTime.now();
    int messageTime = currentTime.millisecondsSinceEpoch;
    String messageKeyID = reference.push().key;
    String lastConversationID = AppData.supportUID + widget.senderUID;

    final conversationRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.conversationsDB)
        .child(lastConversationID);

    conversationRef.set({
      AppData.messageKeyID: messageKeyID,
      AppData.partyID: lastConversationID,
      AppData.messageID: widget.messageID,
      AppData.messageText: messageText,
      AppData.messageSenderEmail: widget.senderEmail,
      AppData.messageImageUrl: imageUrl,
      AppData.messageSenderName: widget.senderName,
      AppData.messageSenderImage: widget.senderImage,
      AppData.messageSenderUID: AppData.supportUID,
      AppData.messageReceiverUID: widget.senderUID,
      AppData.messageSeen: false,
      AppData.messageRead: false,
      AppData.messageTime: messageTime,
    });

    reference.child(messageKeyID).set({
      AppData.messageKeyID: messageKeyID,
      AppData.messageID: widget.messageID,
      AppData.messageText: messageText,
      AppData.messageSenderEmail: email,
      AppData.messageImageUrl: imageUrl,
      AppData.messageSenderName: fullName,
      AppData.messageSenderImage: profileImgUrl,
      AppData.messageSenderUID: AppData.supportUID,
      AppData.messageReceiverUID: widget.senderUID,
      AppData.messageSeen: false,
      AppData.messageRead: false,
      AppData.messageTime: messageTime,
    });

    //analytics.logEvent(name: 'send_message');
  }

  void updateMessageSeenRead() {
    String lastConversationID = AppData.supportUID + widget.messageID;

    Map<String, dynamic> seenRead = new Map();
    seenRead[AppData.messageSeen] = true;
    seenRead[AppData.messageRead] = true;

    FirebaseDatabase.instance
        .reference()
        .child(AppData.conversationsDB)
        .child(lastConversationID)
        .update(seenRead);

    FirebaseDatabase.instance
        .reference()
        .child(AppData.messagesDB)
        .child(widget.messageID)
        .child(widget.messageKeyID)
        .update(seenRead);
  }
}

class ChatMessage extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final String userid;
  TimeAgo timeAgoo = new TimeAgo();
  BuildContext context;
  Size screenSize;

  //DateTime time = new DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch).;

  ChatMessage({this.messageSnapshot, this.animation, this.userid});

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return new SizeTransition(
      sizeFactor:
          new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: userid == messageSnapshot.value[AppData.messageSenderUID]
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
          child: new Container(
        margin: new EdgeInsets.only(left: 120.0),
        padding: const EdgeInsets.all(8.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topRight: new Radius.circular(25.0),
            topLeft: new Radius.circular(10.0),
            bottomLeft: new Radius.circular(10.0),
            bottomRight: new Radius.circular(0.0),
          ),
        ),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text(messageSnapshot.value[AppData.messageSenderName],
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  new Container(
                      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: messageSnapshot.value[AppData.messageImageUrl] !=
                                  null ||
                              messageSnapshot.value[AppData.messageImageUrl] ==
                                  ""
                          ? new Image.network(
                              messageSnapshot.value[AppData.messageImageUrl],
                              width: 200.0,
                            )
                          : new Text(
                              messageSnapshot.value[AppData.messageText])),
                  new Text(
                      timeAgoo.timeUpdater(
                          new DateTime.fromMillisecondsSinceEpoch(
                              messageSnapshot.value[AppData.messageTime])),
                      style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w100)),
                ],
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: messageSnapshot.value[AppData.messageImageUrl] ==
                                "" ||
                            messageSnapshot.value[AppData.messageImageUrl] ==
                                null
                        ? new CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: new NetworkImage(messageSnapshot
                                .value[AppData.messageSenderImage]),
                          )
                        : new CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                new AssetImage("assets/images/avatar.png"),
                          )),
              ],
            )
          ],
        ),
      ))
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Expanded(
          child: new Container(
        padding: const EdgeInsets.all(8.0),
        margin: new EdgeInsets.only(right: 120.0),
        decoration: new BoxDecoration(
            color: Colors.pink[900],
            borderRadius: new BorderRadius.only(
              topRight: new Radius.circular(10.0),
              topLeft: new Radius.circular(25.0),
              bottomRight: new Radius.circular(10.0),
              bottomLeft: new Radius.circular(0.0),
            )),
        child: new Row(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: messageSnapshot.value[AppData.messageImageUrl] ==
                                "" ||
                            messageSnapshot.value[AppData.messageImageUrl] ==
                                null
                        ? new CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                new AssetImage("assets/images/avatar.png"),
                          )
                        : new CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: new NetworkImage(messageSnapshot
                                .value[AppData.messageSenderImage]),
                          )),
              ],
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(messageSnapshot.value[AppData.messageSenderName],
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child:
                        messageSnapshot.value[AppData.messageImageUrl] != null
                            ? new Image.network(
                                messageSnapshot.value[AppData.messageImageUrl],
                                width: 200.0,
                              )
                            : new Text(
                                messageSnapshot.value[AppData.messageText],
                                style: new TextStyle(color: Colors.white),
                              ),
                  ),
                  new Text(
                      timeAgoo.timeUpdater(
                          new DateTime.fromMillisecondsSinceEpoch(
                              messageSnapshot.value[AppData.messageTime])),
                      style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100)),
                ],
              ),
            ),
          ],
        ),
      ))
    ];
  }
}
