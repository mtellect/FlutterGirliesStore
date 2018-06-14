import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/base.dart';
import 'package:girlies/models/fbconn.dart';
import 'package:girlies/support/screens/account_recovery.dart';
import 'package:girlies/support/screens/add_prodcuts.dart';
import 'package:girlies/support/screens/boutique_store.dart';
import 'package:girlies/support/screens/chat_screen.dart';
import 'package:girlies/support/screens/order_search.dart';
import 'package:girlies/support/screens/support_order_history.dart';
import 'package:girlies/support/screens/support_orders.dart';

class GirliesSupport extends StatefulWidget {
  @override
  _GirliesSupportState createState() => new _GirliesSupportState();
}

class _GirliesSupportState extends State<GirliesSupport> {
  int _currentPage = 0;
  PageController _pageController;
  Base base = new Base.products();
  Base messageModel = new Base.messages();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  final userRef = FirebaseDatabase.instance.reference().child(AppData.userDB);
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription<Event> _cartSubscription;
  BuildContext context;
  FirebaseUser user;
  FirebaseAuth _auth;
  int requestCount;

  String userid;
  bool isLoggedIn;
  String _btnText;
  bool _isSignedIn = false;

  String _platformMessage = 'Unknown';
  String _camera = 'fromCameraCropImage';
  String _gallery = 'fromGalleryCropImage';
  File imageFile;

  String supportUID = "08143733836Girlies";
  String fullName = "Girlies Support";
  String email = "girlies.suport@gmail.com";
  String phone = "08143733836";

  String profileImgUrl =
      "https://www.ngmark.com/merchant/wp-content/uploads/2017/11/customers1-1.jpg";

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _pageController = new PageController();
    _getRequestCount();
    super.initState();
  }

  Future _getRequestCount() async {
    final cartRef =
        FirebaseDatabase.instance.reference().child(AppData.notifyAdminOrderDB);

    _cartSubscription = cartRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        requestCount = 0;
        setState(() {});
        return;
      }
      Map valFav = event.snapshot.value;
      FbConn fbConn = new FbConn(valFav);
      requestCount = fbConn.getDataSize();
      setState(() {});
    });
  }

  Future _getCurrentUser() async {
    await _auth.currentUser().then((user) {
      //_getCartCount();
      if (user != null) {
        setState(() {
          _btnText = "Logout";
          _isSignedIn = true;
          email = user.email;
          fullName = user.displayName;
          profileImgUrl = user.photoUrl;
          AppData.currentUserID = user.uid;
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
          _isSignedIn = false;
          fullName = null;
          profileImgUrl = null;
          email = null;
          AppData.currentUserID = null;
          nameController.text = null;
        });
      } else {
        setState(() {
          _isSignedIn = true;
          email = user.email;
          fullName = user.displayName;
          profileImgUrl = user.photoUrl;
          AppData.currentUserID = user.uid;
          nameController.text = fullName;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
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

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: new Stack(
        children: <Widget>[
          new FloatingActionButton(
            mini: false,
            onPressed: () {
              Base orderModel = new Base.adminOrder();
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new SupportOrders(
                        orders: orderModel.buildDemoAdminOrder(),
                      )));
              //listAlertDialog();
            },
            tooltip: 'Your Requests',
            child: new Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          new CircleAvatar(
            radius: 10.0,
            backgroundColor: Colors.red[900],
            child: new Text(
              requestCount == null ? "0" : requestCount.toString(),
              style: new TextStyle(color: Colors.white, fontSize: 9.0),
            ),
          )
        ],
      ),
      endDrawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: new BoxDecoration(color: MyApp.appColors[600]),
              accountName: new Text(
                  fullName != null ? fullName : fullName = "Your Name"),
              accountEmail:
                  new Text(email != null ? email : email = "you@email.com"),
              currentAccountPicture: profileImgUrl != null
                  ? new CircleAvatar(
                      backgroundColor: Color(0xff7c94b6),
                      backgroundImage: new NetworkImage(profileImgUrl),
                    )
                  : email != null
                      ? new CircleAvatar(
                          backgroundColor: Colors.white,
                          child: new Text(
                            email.substring(0, 2).toUpperCase(),
                            style: new TextStyle(
                                color: MyApp.appColors,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : new CircleAvatar(
                          backgroundColor: Colors.white,
                          child: new Text(
                            "Y",
                            style: new TextStyle(
                                color: MyApp.appColors,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
              otherAccountsPictures: <Widget>[
                /* new CircleAvatar(
                  backgroundColor: Color(0xff7c94b6),
                  backgroundImage: new NetworkImage(profileImgUrl),
                )*/
              ],
            ),
            new ListTile(
              title: new Text("Find Order"),
              leading: new CircleAvatar(
                backgroundColor: Colors.pink[900],
                child: new Icon(Icons.search, color: Colors.white),
              ),
              onTap: () {
                //Navigator.of(context).pop();
                final dialog = new AlertDialog(
                  title: new Text("Find Order (Mobile No)"),
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
                          findUserOrder();
                        },
                        child: new Text("Find")),
                  ],
                );
                showDialog(context: context, child: dialog);
              },
            ),
            new ListTile(
              title: new Text("Find User Orders"),
              leading: new CircleAvatar(
                backgroundColor: Colors.pink[900],
                child: new Icon(Icons.find_in_page, color: Colors.white),
              ),
              onTap: () {
                //Navigator.of(context).pop();
                final dialog = new AlertDialog(
                  title: new Text("Find Order (Mobile No)"),
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
                          findUserOrder();
                        },
                        child: new Text("Find")),
                  ],
                );
                showDialog(context: context, child: dialog);
              },
            ),
            new ListTile(
              title: new Text("Order History"),
              leading: new CircleAvatar(
                backgroundColor: Colors.pink[900],
                child: new Icon(Icons.history, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new GirliesSupportOrderHistory()));
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("My Boutique"),
              leading: new CircleAvatar(
                backgroundColor: Colors.pink[900],
                child: new Icon(
                  Icons.store,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new BoutiqueStore()));
              },
            ),
            new ListTile(
              title: new Text("Add Products"),
              leading: new CircleAvatar(
                backgroundColor: Colors.pink[900],
                child: new Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new AddProducts()));
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("Account Handler"),
              leading: new CircleAvatar(
                backgroundColor: Colors.pink[900],
                child: new Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new SupportAccountRecovery()));
              },
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        title: new SizedBox(
          height: 40.0,
          child: new Image.asset(
            "assets/images/girlies_text_support.png",
            height: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: new ChatScreen(
        messages: messageModel.buildDemoMessages(),
      ),
    );
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  void _onNavigationTap(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._currentPage = page;
    });
  }

  void findUserOrder() {
    Navigator.of(context).pop();
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new GirliesOrderSearch()));
  }

  void findAllUserOrder() {
    Navigator.of(context).pop();
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new GirliesOrderSearch()));
  }
}
