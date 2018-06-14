import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:girlies/app/girlies_app.dart';
import 'package:girlies/navigation.dart';
import 'package:girlies/support/girlies_support.dart';

void main() {
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.setPersistenceCacheSizeBytes(1000000000);
  FirebaseDatabase.instance.reference().keepSynced(true);
  runApp(new MyApp());
}

var routes = <String, WidgetBuilder>{
  ScreenNavigator.login: (BuildContext context) {
    return null;
  },
  ScreenNavigator.signup: (BuildContext context) {
    return null;
  },
  ScreenNavigator.girlie: (BuildContext context) {
    return new GirliesApp();
  },
  ScreenNavigator.support: (BuildContext context) {
    return GirliesSupport();
  },
  ScreenNavigator.controller: (BuildContext context) {
    return null;
  },
};

final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.pink,
    primaryColor: Color(0xFF991155),
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.pink,
    accentColor: Color(0xFF991155),
    primaryColor: Color(0xFF991155),
    splashColor: Colors.pink[900]);

class MyApp extends StatelessWidget {
  /*keytool -list -v -keystore C:\Users\MAUGOST\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android*/
//  1D:70:80:2D:53:71:89:AB:D2:24:F0:FB:36:71:25:61

//  keytool -exportcert -alias androiddebugkey -keystore "C:\Users\MAUGOST\.android\debug.keystore" | "C:\Users\MAUGOST\Documents\openssl-0.9.8k_WIN32\bin\openssl" sha1 -binary | "C:\Users\MAUGOST\Documents\openssl-0.9.8k_WIN32\bin\openssl" base64

  static const appColors = ColorSwatch(0xFF991155, {
    "appColor": Color(0xFF991155),
    100: Color(0xFFff1d8e),
    200: Color(0xFFe51a7f),
    300: Color(0xFFcc1771),
    400: Color(0xFFb21463),
    500: Color(0xFF991155),
    600: Color(0xFF7f0e47),
    700: Color(0xFF660b38),
    800: Color(0xFF4c082a),
    900: Color(0xFF33051c),
    1000: Color(0xFF19020e),
    0000: Color(0xFF000000),
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Girlies',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new GirliesApp(),
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
