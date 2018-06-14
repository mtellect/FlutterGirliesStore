import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/data.dart';
import 'package:girlies/app/screens/cart.dart';
import 'package:girlies/main.dart';
import 'package:girlies/models/base.dart';
import 'package:girlies/models/fbconn.dart';

class BoutiqueItem extends StatefulWidget {
  final productImage;
  final productPrice;
  int productQuantity;
  final productTitle;
  final productCategory;
  final List<Base> productList;
  final sizesAvailable;
  final colorsAvailable;
  final FbConn fbConn;
  final String itemKey;
  final index;
  final bool isInFavorite;

  BoutiqueItem(
      {Key key,
      this.productImage,
      this.productPrice,
      this.productTitle,
      this.productCategory,
      this.productList,
      this.productQuantity,
      this.fbConn,
      this.sizesAvailable,
      this.colorsAvailable,
      this.itemKey,
      this.index,
      this.isInFavorite})
      : super(key: key);

  @override
  _BoutiqueItemState createState() => new _BoutiqueItemState();
}

class _BoutiqueItemState extends State<BoutiqueItem> {
  List<Base> subList = new List();
  FbConn fbConnSub;

  List<DropdownMenuItem<String>> _dropDownColors;
  String _selectedColors;

  List<DropdownMenuItem<String>> _dropDownSizes;
  String _selectedSize;

  List<String> sizesAvList = new List();
  List<String> colorsAvList = new List();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final PageController controller = new PageController();
  BuildContext context;
  StreamSubscription<Event> _cartSubscription;
  int cartCount;
  bool isInCart = false;
  bool isFavorite;
  int defaultQuantity = 1;

  void showInSnackBar(String value) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isFavorite = widget.isInFavorite;
    });
    sizesAvList = widget.sizesAvailable.toString().split(",").toList();
    colorsAvList = widget.colorsAvailable.toString().split(",").toList();

    _dropDownColors = buildAndGetDropDownQuantity(colorsAvList);
    _selectedColors = _dropDownColors[0].value;

    _dropDownSizes = buildAndGetDropDownSizes(sizesAvList);
    _selectedSize = _dropDownSizes[0].value;

    Map altList = new Map();
    altList.addAll(widget.fbConn.getListMap());

    bool data = altList.containsKey(widget.itemKey);
    if (data) {
      altList.remove(widget.itemKey);
      print(data);
    }

    _getCartCount();

    fbConnSub = new FbConn(altList);
    List<String> sKey = new List();
    print(fbConnSub.getDataSize());
    for (int s = 0; s < fbConnSub.getDataSize(); s++) {
      if (fbConnSub.getProductCategoryAsList()[s] != widget.productCategory) {
        String key = fbConnSub.getKeyIDasList()[s];
        sKey.add(key);
      }
    }
    print(sKey.length);
    for (int s = 0; s < sKey.length; s++) {
      fbConnSub.getListMap().remove(sKey[s]);
    }

    print(fbConnSub.getDataSize());
    //FbConn subConn = new FbConn(altList);
  }

  @override
  void dispose() {
    _cartSubscription.cancel();
    super.dispose();
  }

  Future _getCartCount() async {
    if (AppData.currentUserID == "" || AppData.currentUserID == null) return;
    final cartRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.cartDB)
        .child(AppData.currentUserID);

    _cartSubscription = cartRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        isInCart = false;
        cartCount = 0;
        setState(() {});
        return;
      }
      Map valFav = event.snapshot.value;
      FbConn fbConn = new FbConn(valFav);
      cartCount = fbConn.getDataSize();
      for (int s = 0; s < fbConn.getDataSize(); s++) {
        String key = fbConn.getKeyIDasList()[s];
        if (key == widget.itemKey) {
          isInCart = true;
        }
      }
      setState(() {});
    });
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownQuantity(List quantity) {
    List<DropdownMenuItem<String>> items = new List();
    for (String quantity in quantity) {
      items.add(
          new DropdownMenuItem(value: quantity, child: new Text(quantity)));
    }
    return items;
  }

  void changedDropDownColors(String selectedColors) {
    setState(() {
      _selectedColors = selectedColors;
    });
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownSizes(List size) {
    List<DropdownMenuItem<String>> items = new List();
    for (String size in size) {
      items.add(new DropdownMenuItem(value: size, child: new Text(size)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownKitchen(List size) {
    List<DropdownMenuItem<String>> items = new List();
    for (String size in size) {
      items.add(new DropdownMenuItem(value: size, child: new Text(size)));
    }
    return items;
  }

  void changedDropDownSize(String selectedSize) {
    setState(() {
      _selectedSize = selectedSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: new Container(
        height: 50.0,
        color: MyApp.appColors[600],
        child: new Row(
          children: <Widget>[
            isFavorite == true
                ? new GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.fbConn.removeFavorite(widget.index);
                        showInSnackBar(
                            /*widget.fbConn.getProductNameAsList()[widget.index] +*/
                            " Removed from your favorites");
                        isFavorite = false;
                      });
                    },
                    child: new Container(
                      width: 160.0,
                      height: 50.0,
                      color: Colors.white,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Icon(
                                Icons.favorite,
                                color: MyApp.appColors[600],
                                size: 20.0,
                              )),
                          new Text(
                            "REMOVE FAVORITE",
                            style: new TextStyle(
                                fontSize: 12.0,
                                color: MyApp.appColors[600],
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  )
                : new GestureDetector(
                    onTap: () {
                      widget.fbConn.addIsFavoriteIndex(true, widget.index);
                      showInSnackBar(
                          /*widget.fbConn.getProductNameAsList()[widget.index] +*/
                          " Added to your favorites");
                      isFavorite = true;
                      setState(() {});
                    },
                    child: new Container(
                      width: 160.0,
                      height: 50.0,
                      color: Colors.white,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Icon(
                              Icons.favorite_border,
                              color: MyApp.appColors[600],
                              size: 20.0,
                            ),
                          ),
                          new Text(
                            "ADD TO FAVORITE",
                            style: new TextStyle(
                                fontSize: 12.0,
                                color: MyApp.appColors[600],
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
            isInCart == true
                ? new GestureDetector(
                    onTap: () {
                      widget.fbConn.removeFromCart(widget.index);
                      showInSnackBar(
                          /*widget.fbConn.getProductNameAsList()[widget.index] +*/
                          "Removed from your cart");
                      isInCart = false;
                      setState(() {});
                    },
                    child: new Container(
                      width: 180.0,
                      height: 50.0,
                      //color: Colors.white,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                          new Text(
                            "REMOVE FROM CART",
                            style: new TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  )
                : new GestureDetector(
                    onTap: () {
                      widget.fbConn.addToCart(widget.index, defaultQuantity);
                      showInSnackBar(
                          /*widget.fbConn.getProductNameAsList()[widget.index] +*/
                          " Added to your cart");
                      isInCart = true;
                      setState(() {});
                    },
                    child: new Container(
                      width: 180.0,
                      height: 50.0,
                      //color: Colors.white,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 25.0,
                            ),
                          ),
                          new Text(
                            "ADD TO CART",
                            style: new TextStyle(
                                fontSize: 13.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
      appBar: new AppBar(
        title: Text(widget.productCategory,
            style: new TextStyle(color: Colors.white)),
        automaticallyImplyLeading: true,
        centerTitle: false,
        actions: <Widget>[
          new Stack(
            children: <Widget>[
              new IconButton(
                icon: new Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new GirliesCart()));
                },
              ),
              new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new CircleAvatar(
                  radius: 8.0,
                  backgroundColor: Colors.red[900],
                  child: new Text(
                    cartCount == null ? "0" : cartCount.toString(),
                    style: new TextStyle(color: Colors.white, fontSize: 9.0),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new ListView(
          children: <Widget>[
            const Padding(padding: const EdgeInsets.only(top: 12.0)),
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
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
                                      widget.productImage,
                                      width: 300.0,
                                      height: 300.0,
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                    ),
                                    tag: widget.productTitle,
                                  ),
                                ),
                              ),
                            );
                          }));
                    },
                    child: new Hero(
                      tag: widget.productTitle,
                      child: new Container(
                        height: 128.0,
                        width: 128.0,
                        decoration: new BoxDecoration(
                          //color: color,
                          image: new DecorationImage(
                              image: new NetworkImage(widget.productImage)),
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: const EdgeInsets.only(left: 18.0)),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          widget.productTitle,
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        const Padding(padding: const EdgeInsets.only(top: 6.0)),
                        new Text(
                          //'Item number ${widget.index}',
                          "N" + widget.productPrice.toString(),
                          style: const TextStyle(
                            color: const Color(0xFF8E8E93),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        const Padding(padding: const EdgeInsets.only(top: 6.0)),
                        new Text(
                          //'Item number ${widget.index}',
                          "( ${widget.productQuantity}  in  Stock )",
                          style: const TextStyle(
                            color: const Color(0xFF8E8E93),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              margin: new EdgeInsets.only(left: 10.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 0.0, bottom: 2.0),
                    child: new Row(
                      children: <Widget>[
                        const Text(
                          'SIZES AVAILABLE',
                          style: const TextStyle(
                            color: const Color(0xFF646464),
                            //letterSpacing: -0.60,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        new Container(
                          margin: new EdgeInsets.only(left: 60.0),
                          child: new DropdownButton(
                            value: _selectedSize,
                            items: _dropDownSizes,
                            onChanged: changedDropDownSize,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 2.0),
                    child: new Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const Text(
                          'COLORS AVAILABLE',
                          style: const TextStyle(
                            color: const Color(0xFF646464),
                            //letterSpacing: -0.60,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        new Container(
                          margin: new EdgeInsets.only(left: 50.0),
                          child: new DropdownButton(
                            value: _selectedColors,
                            items: _dropDownColors,
                            onChanged: changedDropDownColors,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 2.0),
                    child: new Row(
                      children: <Widget>[
                        const Text(
                          'SET QUANTITY',
                          style: const TextStyle(
                            color: const Color(0xFF646464),
                            //letterSpacing: -0.60,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(left: 60.0)),
                        new CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: new Icon(
                            CupertinoIcons.minus_circled,
                            color: MyApp.appColors[600],
                            semanticLabel: 'Substract',
                          ),
                          onPressed: () {
                            setState(() {
                              if (defaultQuantity == 1) {
                                defaultQuantity == 1;
                                return;
                              }
                              defaultQuantity--;
                            });
                          },
                        ),
                        new Text(
                          defaultQuantity.toString(),
                          style: const TextStyle(
                            color: const Color(0xFF8E8E93),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        new CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: new Icon(
                            CupertinoIcons.plus_circled,
                            color: MyApp.appColors[600],
                            semanticLabel: 'Add',
                          ),
                          onPressed: () {
                            setState(() {
                              defaultQuantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 35.0, bottom: 8.0),
              child: const Text(
                'SIMILAR  MENU  ITEMS:',
                style: const TextStyle(
                  color: const Color(0xFF646464),
                  //letterSpacing: -0.60,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            new SizedBox(
              height: 150.0,
              width: 150.0,
              child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fbConnSub.getDataSize(),
                itemExtent: 160.0,
                itemBuilder: (BuildContext context, int index) {
                  return new Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: new GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator
                              .of(context)
                              .push(new CupertinoPageRoute<void>(
                                builder: (BuildContext context) =>
                                    new BoutiqueItem(
                                      //productList: subList,
                                      productTitle: fbConnSub
                                          .getProductNameAsList()[index],
                                      productPrice: fbConnSub
                                          .getProductPriceAsList()[index],
                                      // index: index,
                                      productImage: fbConnSub
                                          .getDefaultIMGAsList()[index],

                                      productCategory: fbConnSub
                                          .getProductCategoryAsList()[index],
                                      productQuantity: num.parse(fbConnSub
                                          .getProductNoInStockAsList()[index]),
                                      fbConn: widget.fbConn /*fbConnSub*/,
                                      sizesAvailable: fbConnSub
                                          .getProductSizesAsList()[index],
                                      colorsAvailable: fbConnSub
                                          .getProductColorsAsList()[index],
                                      itemKey:
                                          fbConnSub.getKeyIDasList()[index],
                                      index: index,
                                    ),
                              ));
                        },
                        child: new Card(
                          child: new Stack(
                            children: <Widget>[
                              new Image.network(
                                fbConnSub.getDefaultIMGAsList()[index],
                                height: 180.0,
                                width: 150.0,
                              ),
                              new Container(
                                height: 200.0,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  color: Colors.black.withAlpha(120),
                                ),
                                child: new Center(
                                  child: new Text(
                                    fbConnSub.getProductNameAsList()[index],
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
