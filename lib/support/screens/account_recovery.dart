import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/fbconn.dart';
import 'package:girlies/support/screens/account_search.dart';
import 'package:girlies/support/screens/boutique_store.dart';

class SupportAccountRecovery extends StatefulWidget {
  @override
  _SupportHomeState createState() => new _SupportHomeState();
}

class _SupportHomeState extends State<SupportAccountRecovery> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  final userRef = FirebaseDatabase.instance.reference().child(AppData.userDB);
  StreamSubscription<Event> _userSubscription;
  FbConn fbConn;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  FirebaseUser user;
  FirebaseAuth _auth;
  int cartCount;

  String userid;
  bool isLoggedIn;

  String supportUID;
  String fullName;
  String email;
  String phone;

  String profileImgUrl;

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    //_getCurrentUser();
    _getUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    if (_userSubscription != null) _userSubscription.cancel();
    super.dispose();
  }

  Future _getCurrentUser() async {
    await _auth.currentUser().then((user) {
      //_getCartCount();
      if (user != null) {
        setState(() {
          email = user.email;
          fullName = user.displayName;
          profileImgUrl = user.photoUrl;
          userid = user.uid;
          user = user;
        });
      }
    });

    setState(() {
      nameController.text = fullName;
    });

    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        setState(() {
          fullName = null;
          profileImgUrl = null;
          email = null;
//          AppData.currentUserID = null;
          nameController.text = null;
        });
      } else {
        setState(() {
          email = user.email;
          fullName = user.displayName;
          profileImgUrl = user.photoUrl;
//          AppData.currentUserID = user.uid;
          nameController.text = fullName;
        });
      }
    });
  }

  Future _getUserInfo() async {
    final cartRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.userDB)
        .child(AppData.currentUserID);

    print(AppData.currentUserID);

    _userSubscription = await cartRef.once().then((snapshot) {
      if (snapshot.value == null) {
        fbConn = null;
        setState(() {});
        return;
      }
      Map valFav = snapshot.value;

      fbConn = new FbConn(valFav);
      email = fbConn.getEmail();
      fullName = fbConn.getFullName();
      phone = fbConn.getPhoneNumber();
      userid = fbConn.getUserID();
      profileImgUrl = fbConn.getProfileImage();
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
      email = fbConn.getEmail();
      fullName = fbConn.getFullName();
      phone = fbConn.getPhoneNumber();
      userid = fbConn.getUserID();
      profileImgUrl = fbConn.getProfileImage();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final account = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            "Account Settings",
            style: new TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
                onTap: () {
                  final dialog = new AlertDialog(
                    title: new Text("Find Account (Mobile No)"),
                    contentPadding: new EdgeInsets.all(16.0),
                    content: new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new TextField(
                          controller: phoneController,
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          decoration: new InputDecoration(
                              labelText: "Enter Phone Number", hintText: ""),
                        ))
                      ],
                    ),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: new Text("Cancel")),
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(new CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    new SupportAccountSearch(
                                      value: phoneController.text,
                                      orderBy: AppData.phoneNumber,
                                    )));
                          },
                          child: new Text("Find")),
                    ],
                  );
                  showDialog(context: context, child: dialog);
                },
                child: new Container(
                  width: 150.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.pink[900],
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
                          Icons.phone,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      new Text(
                        "By Phone",
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
                onTap: () {
                  final dialog = new AlertDialog(
                    title: new Text("Find Account (Name)"),
                    contentPadding: new EdgeInsets.all(16.0),
                    content: new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new TextField(
                          controller: nameController,
                          autofocus: true,
                          decoration: new InputDecoration(
                              labelText: "Enter Account Name", hintText: ""),
                        ))
                      ],
                    ),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: new Text("Cancel")),
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(new CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    new SupportAccountSearch(
                                      value: nameController.text,
                                      orderBy: AppData.fullName,
                                    )));
                          },
                          child: new Text("Find")),
                    ],
                  );
                  showDialog(context: context, child: dialog);
                },
                child: new Container(
                  width: 150.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.pink[900],
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
                          Icons.person,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      new Text(
                        "By Name",
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ],
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
                onTap: () {
                  final dialog = new AlertDialog(
                    title: new Text("Find Account (Email)"),
                    contentPadding: new EdgeInsets.all(16.0),
                    content: new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new TextField(
                          controller: emailController,
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: new InputDecoration(
                              labelText: "Enter Account Email", hintText: ""),
                        ))
                      ],
                    ),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: new Text("Cancel")),
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(new CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    new SupportAccountSearch(
                                      value: emailController.text,
                                      orderBy: AppData.email,
                                    )));
                          },
                          child: new Text("Find")),
                    ],
                  );
                  showDialog(context: context, child: dialog);
                },
                child: new Container(
                  width: 150.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.pink[900],
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
                          Icons.email,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      new Text(
                        "By Email",
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
                onTap: () {
                  final dialog = new AlertDialog(
                    title: new Text("Find Account (Password)"),
                    contentPadding: new EdgeInsets.all(16.0),
                    content: new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new TextField(
                          controller: passController,
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                              labelText: "Enter Password", hintText: ""),
                        ))
                      ],
                    ),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: new Text("Cancel")),
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(new CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    new SupportAccountSearch(
                                      value: passController.text,
                                      orderBy: AppData.password,
                                    )));
                          },
                          child: new Text("Find")),
                    ],
                  );
                  showDialog(context: context, child: dialog);
                },
                child: new Container(
                  width: 150.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.pink[900],
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
                          Icons.lock,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      new Text(
                        "By Password",
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ],
        ),
      ],
    );
    final profile = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          margin: new EdgeInsets.only(left: 8.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: profileImgUrl == "" || profileImgUrl == null
                    ? new CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage:
                            new AssetImage("assets/images/avatar.png"),
                      )
                    : new CircleAvatar(
                        backgroundColor: MyApp.appColors[600],
                        backgroundImage: new NetworkImage(profileImgUrl),
                      ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text("Girlies Boutique"),
              ),
            ],
          ),
        ),
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            padding: const EdgeInsets.all(4.0),
            margin: new EdgeInsets.only(left: 8.0, right: 8.0),
            width: screenSize.width,
            decoration: new BoxDecoration(
              color: Colors.black12.withAlpha(10),
              borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
            ),
            child: new Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: email == null
                        ? new Text("Email: Not Signed In")
                        : new Text("Email: $email"),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: phone == null
                        ? new Text("Phone: Not Signed In")
                        : new Text("Phone: $phone"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    final boutique = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            "Boutique Settings",
            style: new TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new InkWell(
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new BoutiqueStore()));
                },
                child: new Container(
                  width: 150.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.pink[900],
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
                          Icons.store,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      new Text(
                        "Boutique",
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: 150.0,
                height: 50.0,
                decoration: new BoxDecoration(
                    color: Colors.pink[900],
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
                        Icons.history,
                        size: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    new Text(
                      "History",
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ],
        ),
      ],
    );
    final handler = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            "Support Handler",
            style: new TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        new Container(
          margin: new EdgeInsets.only(left: 8.0, right: 8.0),
          child: new Column(
            children: <Widget>[
              _buildListItem("Reset Account", Icons.replay, () {}),
              _buildListItem("Block Account", Icons.block, () {}),
              _buildListItem("Suspend Account", Icons.pause, () {}),
              _buildListItem("Order Complete", Icons.check, () {}),
              _buildListItem(
                  "Update Order Status", Icons.assignment_late, () {}),
            ],
          ),
        )
      ],
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Account Handler",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: new SingleChildScrollView(
        child: new Container(
          color: Colors.white,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[account, profile, handler],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String title, IconData iconData, VoidCallback action) {
    final textStyle = new TextStyle(color: Colors.black, fontSize: 15.0);

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
              width: 30.0,
              height: 30.0,
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
                onPressed: action)
          ],
        ),
      ),
    );
  }

  void findUserByPhone() {}

  void findUserByName() {}

  void findUserByEmail() {}

  void findUserByPassword() {}
}
