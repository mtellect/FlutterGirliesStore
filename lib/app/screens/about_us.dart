import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GirliesAboutUs extends StatefulWidget {
  @override
  _GirliesAboutUsState createState() => new _GirliesAboutUsState();
}

class _GirliesAboutUsState extends State<GirliesAboutUs> {
  BuildContext context;
  String fullName;
  String email;
  String phone;
  String userid;
  String profileImgUrl;
  bool isLoggedIn;
  String _btnText;
  final googleSignIn = new GoogleSignIn();
  FirebaseUser user;
  FirebaseAuth _auth;
  bool _isSignedIn;
  String aboutUs =
      "Girlies is an e-commerce platform offering only female variety of products ranging from bags, shoes, clothings, tops, jeans, makeups etc at very cheap and affordable prices. Here, we believe that you can be trending without being broke. Let's simplify shopping for you.";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }

  _getCurrentUser() async {
    user = await _auth.currentUser().catchError((error) {
      print(error);
    });

    if (user != null) {
      setState(() {
        _btnText = "Logout";
        _isSignedIn = true;
        email = user.email;
        fullName = user.displayName;
        profileImgUrl = user.photoUrl;
        //profileImgUrl = googleSignIn.currentUser.photoUrl;
      });
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        backgroundColor: MyApp.appColors,
        appBar: new AppBar(
          title: new GestureDetector(
            onLongPress: () {},
            child: new Text(
              "About Us",
              style: new TextStyle(color: Colors.white),
            ),
          ),
          centerTitle: false,
        ),
        resizeToAvoidBottomPadding: false,
        body: new Container(
          constraints: const BoxConstraints(maxHeight: 500.0),
          margin: new EdgeInsets.all(5.0),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
          child: new Center(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                height: 50.0,
                child:
                    new Image.asset("assets/images/girlies_text_colored.png"),
              ),
              new SizedBox(
                height: 50.0,
                child: new Image.asset("assets/images/girlies_logo.png"),
              ),
              new Padding(
                padding: const EdgeInsets.all(2.0),
                child: new Text(
                  "Version 0.0.1",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontStyle: FontStyle.normal),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(2.0),
                child: new Text(
                  "Girlies, we are here for the ladies...",
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.black26,
                      fontStyle: FontStyle.italic),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Text(
                  aboutUs,
                  style: new TextStyle(
                      fontSize: 15.0,
                      color: MyApp.appColors,
                      fontStyle: FontStyle.normal,
                      wordSpacing: 2.0),
                ),
              ),
            ],
          )),
        ));
  }

  Widget _buildListItem(String title, IconData iconData, VoidCallback action) {
    final textStyle =
        new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500);

    return new InkWell(
      onTap: action,
      child: new Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: 35.0,
              height: 35.0,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: new BoxDecoration(
                color: MyApp.appColors[600],
                borderRadius: new BorderRadius.circular(5.0),
              ),
              alignment: Alignment.center,
              child: new Icon(iconData, color: Colors.white, size: 20.0),
            ),
            new Text(title, style: textStyle),
            new Expanded(child: new Container()),
            new IconButton(
                icon: new Icon(Icons.chevron_right, color: Colors.black26),
                onPressed: null)
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final mainTextStyle = new TextStyle(
        fontFamily: 'Timeburner',
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 20.0);
    final subTextStyle = new TextStyle(
        fontFamily: 'Timeburner',
        fontSize: 16.0,
        color: Colors.white70,
        fontWeight: FontWeight.w500);

    return new Container(
      margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: new Row(
        children: <Widget>[
          new GestureDetector(
            //onTap: isLoggedIn == true ? setProfilePicture : null,
            child: new Container(
              width: 70.0,
              height: 70.0,
              margin: new EdgeInsets.only(left: 10.0),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: profileImgUrl != null
                        ? new NetworkImage(profileImgUrl)
                        : new NetworkImage("http://i.imgur.com/QSev0hg.jpg"),
                    fit: BoxFit.cover),
                borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      spreadRadius: 1.0),
                ],
              ),
            ),
          ),
          new Padding(padding: const EdgeInsets.only(right: 20.0)),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(fullName != null ? fullName : fullName = "Your Name",
                  style: mainTextStyle),
              new Text(email != null ? email : email = "Your Email",
                  style: subTextStyle),
              new Text(phone != null ? phone : phone = "Your Number",
                  style: subTextStyle),
            ],
          ),
        ],
      ),
    );
  }

  Future _signOut() async {
    await _auth.signOut();
    googleSignIn.signOut();
    showInSnackBar('User logged out');
    setState(() {
      _isSignedIn = false;
      fullName = null;
      email = null;
      phone = null;
      profileImgUrl = null;
    });
  }
}
