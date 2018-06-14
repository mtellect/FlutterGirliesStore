import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/screens/order_history.dart';
import 'package:girlies/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GirliesProfile extends StatefulWidget {
  @override
  _GirliesBoutiqueState createState() => new _GirliesBoutiqueState();
}

class _GirliesBoutiqueState extends State<GirliesProfile> {
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

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        appBar: new AppBar(
          title: new GestureDetector(
            onLongPress: () {},
            child: new Text(
              "Profile Settings",
              style: new TextStyle(color: Colors.white),
            ),
          ),
          centerTitle: true,
        ),
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: new Container(
          constraints: const BoxConstraints(maxHeight: 500.0),
          child: new Column(
            //padding: const EdgeInsets.only(left: 5.0),
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                child: new DecoratedBox(
                  child: _buildAvatar(),
                  decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(5.0)),
                      color: MyApp.appColors[400]),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
              _buildListItem("Change Name", Icons.person, () {}),
              _buildListItem("Change Number", Icons.phone_android, () {}),
              _buildListItem("Delivery Address", Icons.home, () {}),
              _buildListItem("Order History", Icons.history, () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new GirliesOrderHistory()));
              }),
              _buildListItem("About Us", Icons.help, () {}),
              new InkWell(
                onTap: _signOut,
                child: new Container(
                  height: 50.0,
                  color: Colors.white,
                  margin: new EdgeInsets.only(top: 20.0),
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Container(
                      width: screenSize.width,
                      margin: new EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 2.0),
                      height: 60.0,
                      decoration: new BoxDecoration(
                          color: MyApp.appColors[400],
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(5.0))),
                      child: new Center(
                          child: new Text(
                        _isSignedIn == false ? "LOGIN" : "LOGOUT",
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
                ),
              )
            ],
          ),
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
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text('User logged out')));
    setState(() {
      _isSignedIn = false;
      fullName = null;
      email = null;
      phone = null;
      profileImgUrl = null;
    });
  }
}
