import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:girlies/app/accounts/signup.dart';
import 'package:girlies/app/channel_methods.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/app/progress.dart';
import 'package:girlies/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GirliesLogin extends StatefulWidget {
  @override
  _GirliesLoginState createState() => new _GirliesLoginState();
}

class _GirliesLoginState extends State<GirliesLogin> {
  BuildContext context;
  String fullName;
  String email;
  String phone;
  String userid;
  String profileImgUrl;
  bool isLoggedIn;
  String _btnText;
  final googleSignIn = new GoogleSignIn();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseUser user;
  FirebaseAuth _auth;
  bool _isSignedIn;
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  final userRef = FirebaseDatabase.instance.reference().child(AppData.userDB);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Logging In....',
  );

  _getCurrentUser() async {
    user = await _auth.currentUser().catchError((error) {
      print(error);
    });

    if (user != null) {
      setState(() {
        _isSignedIn = true;
        AppData.currentUserID = user.uid;
      });
    }

    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        setState(() {
          _isSignedIn = false;
          AppData.currentUserID = null;
        });
      } else {
        _isSignedIn = true;
        AppData.currentUserID = user.uid;
//        Map userMap = new Map();
//        userMap[AppData.fullName] = user.displayName;
//        userMap[AppData.phoneNumber] = "";
//        userMap[AppData.email] = user.email;
//        userMap[AppData.password] = "";
//        userMap[AppData.profileImgURL] = user.photoUrl;
//        userMap[AppData.deliveryAddress] = "";
//        userMap[AppData.userID] = user.uid;
//        userRef.child(user.uid).set(userMap);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        key: scaffoldKey,
        backgroundColor: MyApp.appColors,
        appBar: new AppBar(
          backgroundColor: MyApp.appColors,
          title: new GestureDetector(
            onLongPress: () {},
            child: new Text(
              "Login",
              style: new TextStyle(color: Colors.white),
            ),
          ),
          centerTitle: true,
        ),
        resizeToAvoidBottomPadding: true,
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                height: 120.0,
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          margin: new EdgeInsets.only(top: 20.0, bottom: 0.0),
                          height: 40.0,
                          width: 40.0,
                          child: new Image.asset(
                              'assets/images/girlies_logo.png')),
                      new SizedBox(
                        height: 20.0,
                        child: new Image.asset(
                          "assets/images/girlies_text.png",
                          height: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: new BoxDecoration(
                    color: MyApp.appColors,
                    borderRadius: new BorderRadius.only(
                        bottomLeft: new Radius.circular(20.0),
                        bottomRight: new Radius.circular(20.0))),
              ),
              new Container(
                margin: new EdgeInsets.only(left: 5.0, right: 5.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(20.0),
                        topRight: new Radius.circular(20.0))),
                constraints: const BoxConstraints(maxHeight: 400.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: 60.0,
                      margin: new EdgeInsets.only(top: 5.0),
                      child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Container(
                          width: screenSize.width,
                          margin: new EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 2.0),
                          height: 60.0,
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0))),
                          child: new TextFormField(
                            controller: _emailController,
                            style: new TextStyle(
                                color: MyApp.appColors[500], fontSize: 18.0),
                            decoration: new InputDecoration(
                              prefixIcon: new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: new Icon(
                                  Icons.email,
                                  size: 20.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                              labelText: "Email",
                              labelStyle: new TextStyle(
                                  fontSize: 20.0, color: Colors.black54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      new BorderSide(color: Colors.black54)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      height: 60.0,
                      margin: new EdgeInsets.only(top: 5.0),
                      child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Container(
                          width: screenSize.width,
                          margin: new EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 2.0),
                          height: 60.0,
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0))),
                          child: new TextFormField(
                            controller: _passController,
                            obscureText: true,
                            style: new TextStyle(
                                color: MyApp.appColors[500], fontSize: 18.0),
                            decoration: new InputDecoration(
                              prefixIcon: new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: new Icon(
                                  Icons.lock,
                                  size: 20.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                              labelText: "Password",
                              labelStyle: new TextStyle(
                                  fontSize: 20.0, color: Colors.black54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      new BorderSide(color: Colors.black54)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            new GirliesSignUp()));
                              },
                              child: new Text(
                                "SignUp",
                                style: new TextStyle(
                                    fontSize: 14.0, color: Colors.black),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new Text(
                              "Forgot Password?",
                              style: new TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        loginWithEmail();
                      },
                      child: new Container(
                        height: 60.0,
                        margin: new EdgeInsets.only(top: 5.0),
                        child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Container(
                            width: screenSize.width,
                            margin: new EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 2.0),
                            height: 60.0,
                            decoration: new BoxDecoration(
                                color: MyApp.appColors[400],
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(20.0))),
                            child: new Center(
                                child: new Text(
                              "Login",
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            )),
                          ),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Container(
                            height: 1.0,
                            width: 100.0,
                            color: Colors.black26,
                          ),
                          new Text(
                            "Or login with",
                            style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          new Container(
                            height: 1.0,
                            width: 100.0,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        /*new Column(
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                loginWithFacebook();
                              },
                              child: new Container(
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.blue[800],
                                ),
                                child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30.0,
                                  backgroundImage: new AssetImage(
                                      'assets/images/facebook.png'),
                                ),
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: new Text(
                                "Facebook",
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.blue[800]),
                              ),
                            ),
                          ],
                        ),*/
                        new Column(
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                loginWithGoogle();
                              },
                              child: new Container(
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.yellow[800],
                                ),
                                child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30.0,
                                  backgroundImage: new AssetImage(
                                      'assets/images/google_logo.png'),
                                ),
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: new Text(
                                "Google",
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.yellow[800]),
                              ),
                            ),
                          ],
                        ),
                        /*new Column(
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                loginWithTwitter();
                              },
                              child: new Container(
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.blue[300],
                                ),
                                child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30.0,
                                  backgroundImage: new AssetImage(
                                      'assets/images/twitter.png'),
                                ),
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: new Text(
                                "Twitter",
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.blue[300]),
                              ),
                            ),
                          ],
                        ),*/
                      ],
                    )
                  ],
                ),
              ),
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

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  Future loginWithGoogle() async {
    showDialog(
      context: context,
      child: progress,
    );

    GoogleSignInAccount signedInUser = googleSignIn.currentUser;
    if (signedInUser == null)
      signedInUser = await googleSignIn.signInSilently();
    if (signedInUser == null) {
      await googleSignIn.signIn();
      // analytics.logLogin();
    }
    //currentUserEmail = googleSignIn.currentUser.email;
    if (await _auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      await _auth.signInWithGoogle(
          idToken: credentials.idToken, accessToken: credentials.accessToken);
    }
  }

  Future loginWithFacebook() async {
//    showDialog(
//      context: context,
//      child: progress,
//    );

    String token;

    try {
      token = await GirliesChannels.facebookLogin;
    } on PlatformException catch (e) {
      //Navigator.of(context).pop();
      showInSnackBar(e.message);
    }

    if (token != null) {
      await _auth
          .signInWithFacebook(accessToken: token.toString())
          .catchError((e) {
        //Navigator.of(context).pop();
        showInSnackBar(e.toString());
      });
    }
  }

  Future loginWithTwitter() async {
    showDialog(
      context: context,
      child: progress,
    );

    String token;
    token = await GirliesChannels.facebookLogin;
    if (await _auth.currentUser() == null) {
      await _auth.signInWithTwitter(authToken: token, authTokenSecret: "");
    }
  }

  Future loginWithEmail() async {
    if (_emailController.text == "") {
      showInSnackBar("Email cannot be empty");
      return;
    }

    if (_passController.text == "") {
      showInSnackBar("Password cannot be empty");
      return;
    }

    showDialog(
      context: context,
      child: progress,
    );

    try {
      await _auth
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passController.text)
          .then((loggedUser) {
        this.user = loggedUser;
        isLoggedIn = true;
      });
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
      showInSnackBar(e.message);
    }
  }
}
