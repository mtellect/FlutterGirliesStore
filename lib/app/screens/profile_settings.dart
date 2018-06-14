import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/app/progress.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/fbconn.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GirliesProfileSettings extends StatefulWidget {
  @override
  _GirliesDeliveryAddress createState() => new _GirliesDeliveryAddress();
}

class _GirliesDeliveryAddress extends State<GirliesProfileSettings> {
  TextEditingController productController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  final userRef = FirebaseDatabase.instance.reference().child(AppData.userDB);

  final scaffoldKey = new GlobalKey<ScaffoldState>();
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
  StreamSubscription<Event> _userSubscription;
  FbConn fbConn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
    _getUserInfo();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  Future _getUserInfo() async {
    final cartRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.userDB)
        .child(AppData.currentUserID);

    _userSubscription = await cartRef.once().then((snapshot) {
      if (snapshot.value == null) {
        fbConn = null;
        setState(() {});
        return;
      }
      Map valFav = snapshot.value;
      fbConn = new FbConn(valFav);
      _nameController.text = fbConn.getFullName();
      _mobileController.text = fbConn.getPhoneNumber();
      userid = fbConn.getUserID();
      setState(() {});
    });

    _userSubscription = cartRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        fbConn = null;
        setState(() {});
        return;
      }
      Map valFav = event.snapshot.value;
      fbConn = new FbConn(valFav);
      _nameController.text = fbConn.getFullName();
      _mobileController.text = fbConn.getPhoneNumber();
      userid = fbConn.getUserID();
      setState(() {});
    });
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Saving Details....',
  );

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new GestureDetector(
            onLongPress: () {},
            child: new Text(
              "Profile Settings",
              style: new TextStyle(color: Colors.white),
            ),
          ),
          centerTitle: false,
        ),
        resizeToAvoidBottomPadding: false,
        body: new Container(
            child: new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.only(top: 10.0)),
            new Container(
              height: 50.0,
              margin: new EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 12.0, bottom: 5.0),
              child: new TextFormField(
                controller: _nameController,
                style:
                    new TextStyle(color: MyApp.appColors[500], fontSize: 18.0),
                decoration: new InputDecoration(
                  prefixIcon: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Icon(
                      Icons.person,
                      size: 20.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(12.0),
                  labelText: "Full Name",
                  labelStyle:
                      new TextStyle(fontSize: 20.0, color: Colors.black54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black54)),
                ),
              ),
            ),
            new Container(
              height: 50.0,
              margin: new EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: new TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.number,
                style:
                    new TextStyle(color: MyApp.appColors[500], fontSize: 18.0),
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  prefixIcon: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Icon(
                      Icons.phone,
                      size: 20.0,
                    ),
                  ),
                  labelText: "Phone Number",
                  labelStyle:
                      new TextStyle(fontSize: 20.0, color: Colors.black54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black54)),
                ),
              ),
            ),
            new InkWell(
              onTap: _saveProfile,
              child: new Container(
                height: 60.0,
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
                      "Save",
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    )),
                  ),
                ),
              ),
            )
          ],
        )));
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

  Future _saveProfile() async {
    if (_nameController.text == "") {
      showInSnackBar("Name cannot be empty");
      return;
    }

    if (_mobileController.text == "") {
      showInSnackBar("Mobile cannot be empty");
      return;
    }

    showDialog(
      context: context,
      child: progress,
    );

    Map<String, dynamic> userMap = new Map();
    userMap[AppData.fullName] = _nameController.text;
    userMap[AppData.phoneNumber] = _mobileController.text;
    await userRef.child(userid).update(userMap);
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = _nameController.text;
    _auth.updateProfile(userUpdateInfo);
    Navigator.of(context).pop();
    showInSnackBar("Profile Updated");
  }
}
