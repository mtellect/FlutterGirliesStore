import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:girlies/app/accounts/login.dart';
import 'package:girlies/app/alert_dialog.dart';
import 'package:girlies/app/channel_methods.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/app/progress.dart';
import 'package:girlies/app/screens/delivery_address.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/base.dart';
import 'package:girlies/models/fbconn.dart';

class OrderSummary extends StatefulWidget {
  final cartTotal;
  final totalItems;

  OrderSummary({this.cartTotal, this.totalItems});

  @override
  _SupportOrdersState createState() => new _SupportOrdersState();
}

class _SupportOrdersState extends State<OrderSummary> {
  Base orderModel = new Base.products();
  double deliveryFee = 0.00;
  double discountFee = 0.00;
  double totalPayable;
  int _value = 0;
  int groupValue;
  BuildContext context;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription<Event> _userSubscription;
  FbConn fbConn;
  String transcation = 'No transcation Yet';
  Map<String, dynamic> _data = {};

  static const platform = const MethodChannel('maugost.com/paystack_flutter');
  static const paystack_pub_key = "Your_paystack_public_key";
  static const paystack_backend_url =
      "https://infinite-peak-60063.herokuapp.com";

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future _getUserInfo() async {
    final cartRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.userDB)
        .child(AppData.currentUserID);

    _userSubscription = cartRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        fbConn = null;
        setState(() {});
        return;
      }
      Map valFav = event.snapshot.value;
      fbConn = new FbConn(valFav);
      setState(() {});
    });
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
                color: Colors.pink,
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

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final paymentOptions = new Wrap(
      children: new List<Widget>.generate(
        2,
        (int index) {
          return new ChoiceChip(
            label: new Text(index == 0
                ? "Pay with ATM card"
                : "Pay on delivery (Abia-Umuahia Only)"),
            selected: _value == index,
            onSelected: (bool selected) {
              _value = selected ? index : null;
            },
          );
        },
      ).toList(),
    );

    final deliveryOptions = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /*new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Text(
              "PAYMENT OPTIONS",
              style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
            ),
          ),
        ),*/
        new RadioListTile(
            value: 0,
            title: new Text("Pay now (Outside Abia-Umuahia)"),
            groupValue: groupValue,
            onChanged: (int changed) {
              setPaymentMethod(changed);
            }),
        new RadioListTile(
            value: 1,
            title: new Text("Pay now (Abia-Umuahia Only)"),
            groupValue: groupValue,
            onChanged: (int changed) {
              setPaymentMethod(changed);
            }),
        new RadioListTile(
            value: 2,
            title: new Text(
              "Pay on delivery  (Abia-Umuahia Only)",
            ),
            groupValue: groupValue,
            onChanged: (int changed) {
              setPaymentMethod(changed);
            }),
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Text(
              "PRICE DETAILS",
              style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );

    final priceSummary = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          color: Colors.white,
          margin: new EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 20.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                child: new Container(
                  height: 35.0,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Cart Total Items",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        new Text(
                          widget.totalItems,
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ]),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                child: new Container(
                  height: 35.0,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Cart Total Amount",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        new Text(
                          widget.cartTotal.toString(),
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ]),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                child: new Container(
                  height: 35.0,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Delivery Fee",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        new Text(
                          deliveryFee == null
                              ? "N0"
                              : "N" + deliveryFee.toString(),
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.pink[900]),
                        ),
                      ]),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                child: new Container(
                  height: 35.0,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Discount",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        new Text(
                          discountFee == null
                              ? "N0"
                              : "N" + discountFee.toString(),
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.pink[900]),
                        ),
                      ]),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                child: new Container(
                  height: 35.0,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Total Payable",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        new Text(
                          totalPayable == null
                              ? " N" +
                                  (double.parse(widget.cartTotal) +
                                          discountFee +
                                          deliveryFee)
                                      .toString()
                              : "N" + totalPayable.toString(),
                          style: new TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.w700),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
        new GestureDetector(
          onTap: () {
            groupValue != null && groupValue == 0
                ? payWithATM()
                : groupValue != null && groupValue == 1 || groupValue == 2
                    ? payWithCard()
                    : showInSnackBar("Please select a mode of payment.", false);
          },
          child: new Container(
            height: 50.0,
            margin: new EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: new BoxDecoration(
                color: Colors.pink[900],
                borderRadius: new BorderRadius.all(new Radius.circular(5.0))),
            child: new Center(
                child: new Text(
              "PLACE ORDER",
              style: new TextStyle(
                color: Colors.white,
              ),
            )),
          ),
        ),
        new Padding(padding: new EdgeInsets.all(8.0))
      ],
    );
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Cart Summary",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: new ListView(
        children: <Widget>[
          /* new _OrderLists(
            orders: orderModel.buildDemoProducts(),
          ),*/
          deliveryOptions,
          priceSummary
        ],
      ),
    );
  }

  void setPaymentMethod(int changed) {
    setState(() {
      if (changed == 0) {
        groupValue = 0;
        deliveryFee = 1500.00;
        totalPayable =
            double.parse(widget.cartTotal) + discountFee + deliveryFee;
      } else if (changed == 1) {
        groupValue = 1;
        deliveryFee = 500.00;
        totalPayable =
            double.parse(widget.cartTotal) + discountFee + deliveryFee;
      } else if (changed == 2) {
        groupValue = 2;
        deliveryFee = 500.00;
        totalPayable = discountFee + deliveryFee;
      }
    });
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Processing wait....',
  );

  void showInSnackBar(String value, bool loggedIn) {
    loggedIn == true
        ? scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text(value),
            action: new SnackBarAction(
                label: "Login",
                onPressed: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new GirliesLogin()));
                }),
          ))
        : scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text(value),
          ));
  }

  payWithATM() async {
    if (fbConn.getState() == "" &&
        fbConn.getHomeAddress() == "" &&
        fbConn.getHomeDescription() == "") {
      showAlertDialog();
      return;
    }
    showProceedDialog();
  }

  payWithCard() {
    if (fbConn.getState() == "" &&
        fbConn.getHomeAddress() == "" &&
        fbConn.getHomeDescription() == "") {
      showAlertDialog();
      return;
    }
    showProceedDialog();
  }

  showAlertDialog() {
    var alertDialog = new CustomAlertDialog(
      borderRadius: 5.0,
      setTitle: "No Delivery Address!",
      setMessage: 'Please setup your delivery address to proceed.',
      onProceed: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(new CupertinoPageRoute(
            builder: (BuildContext context) => new GirliesDeliveryAddress(
                  fromPayment: true,
                )));
      },
    );
    showDialog(context: context, child: alertDialog);
  }

  showProceedDialog() {
    var alertDialog = new CustomAlertDialog(
      borderRadius: 5.0,
      setTitle: "Your Delivery Address?",
      btnText: "Pay: N" + totalPayable.toString().toString(),
      setMessage: "Home: " +
          fbConn.getHomeAddress() +
          "\n" +
          "Description: " +
          fbConn.getHomeDescription(),
      onProceed: () {
        //openPaystackPortal();
        cartTransferToAdmin();
      },
    );
    showDialog(context: context, child: alertDialog);
  }

  completeProccess() {
    showInSnackBar("Paying on delivery", false);
  }

  Future openPaystackPortal() async {
    showDialog(
      context: context,
      child: progress,
    );
    String result;
    try {
      result = await GirliesChannels.connectToPaystack({
        "NAME": "Your Name",
        "EMAIL": "you@email.com",
        "AMOUNT": 100,
        "CURRENCY": "NGN",
        "PAYMENT_FOR": "Testing API",
        "PAYSTACK_PUBLIC_KEY": paystack_pub_key,
        "BACKEND_URL": paystack_backend_url,
      });
    } on PlatformException catch (e) {
      result = e.message;
      print(e.message);
      Navigator.of(context).pop();
      showInSnackBar(e.message, false);
    }

    if (!mounted) return;

    setState(() {
      transcation = result;
      if (result == "UNSUCCESSFULL PAYSTACK PAYMENT") {
        Navigator.of(context).pop();
        showInSnackBar(result, false);
      }
    });
  }

  Future cartTransferToAdmin() async {
    showDialog(
      context: context,
      child: progress,
    );

    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child(AppData.cartDB)
        .child(AppData.currentUserID);

    reference.once().then((snapshot) {
      Map cartData = snapshot.value;
      String requestKeyID = reference.push().key;
      Map notifyAdmin = createAdminRequest(requestKeyID);
      showInSnackBar(cartData.toString(), true);
      //notify admin for new order request
      FirebaseDatabase.instance
          .reference()
          .child(AppData.notifyAdminOrderDB)
          .child(requestKeyID)
          .set(notifyAdmin);

      //notify user of newly placed order
      FirebaseDatabase.instance
          .reference()
          .child(AppData.orderNotifyDB)
          .child(AppData.currentUserID)
          .child(requestKeyID)
          .set(notifyAdmin);

      //store request information into admin orders
      FirebaseDatabase.instance
          .reference()
          .child(AppData.adminOrdersDB)
          .child(requestKeyID)
          .set(cartData)
          .whenComplete(() {
        //clear user cart after order has been placed and go home
        return clearToHome(reference);
      });
    });
  }

  Map createAdminRequest(String requestKeyID) {
    DateTime currentTime = new DateTime.now();
    int orderTime = currentTime.millisecondsSinceEpoch;

    int orderType = groupValue == 0
        ? AppData.TYPE_PAYNOW_OUTSIDE_UMUAHIA
        : groupValue == 1
            ? AppData.TYPE_PAYNOW_WITHIN_UMUAHIA
            : AppData.TYPE_PAYNOW_ONLY_UMUAHIA;

    Map request = new Map();
    request[AppData.orderSenderName] = fbConn.getFullName();
    request[AppData.orderSenderImg] = fbConn.getProfileImage();
    request[AppData.userID] = fbConn.getUserID();
    request[AppData.orderAmount] = totalPayable;
    request[AppData.noOforders] = widget.totalItems;
    request[AppData.orderType] = orderType;
    request[AppData.orderTime] = orderTime;
    request[AppData.orderStatus] = AppData.STATUS_PENDING;
    request[AppData.orderSeen] = false;
    request[AppData.orderRead] = false;
    request[AppData.keyID] = requestKeyID;
    return request;
  }

  Future clearToHome(DatabaseReference reference) async {
    reference.remove();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}

class MyThreeOptions extends StatefulWidget {
  @override
  _MyThreeOptionsState createState() => new _MyThreeOptionsState();
}

class _MyThreeOptionsState extends State<MyThreeOptions> {
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return new Wrap(
      children: new List<Widget>.generate(
        3,
        (int index) {
          return new ChoiceChip(
            label: new Text('Item $index'),
            selected: _value == index,
            onSelected: (bool selected) {
              _value = selected ? index : null;
            },
          );
        },
      ).toList(),
    );
  }
}
