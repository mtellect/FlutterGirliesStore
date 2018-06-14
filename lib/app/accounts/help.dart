import 'package:flutter/material.dart';

//List<String> myCriteria = new List();
Map<int, String> myCriteria;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 1;
  List<String> initCriterias = [];
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  void addCriteria() {
    if (count < 6) {
      setState(() {
        count += 1;
      });
    }
  }

  void removeCriteria() {
    if (count <= 6) {
      setState(() {
        if (count == 0) {
          return;
        }
        count -= 1;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    //LIST OF ADDING NEW CRITERIA WIDGETS
    List<Widget> children = new List.generate(
        count,
        (int i) => new SliderWidget(
              index: i,
            ));

    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text("Decision Maker"),
        ),
        body: new SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Column(children: children),
              new SizedBox(
                height: 15.0,
              ),
              new RaisedButton(
                child: new Text("RESET"),
                onPressed: () {
                  setState(() {
                    count = 0;
                  });
                },
              ),
              new SizedBox(
                height: 15.0,
              ),
              new RaisedButton(
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                child: new Text("SUBMIT"),
                onPressed: () {
                  handleOnSubmit();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: new Container(
          height: 80.0,
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new GestureDetector(
                      onTap: addCriteria,
                      child: new CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.blue[900],
                        child: new Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    new GestureDetector(
                      onTap: removeCriteria,
                      child: new CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.blue[900],
                        child: new Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void handleOnSubmit() {
    showInSnackBar(myCriteria.toString());
  }
}

//NEW WIDGET FOR CRITERIA - TEXT FIELDS ARE HERE
class SliderWidget extends StatefulWidget {
  final int index;

  SliderWidget({this.index});

  @override
  _SliderWidgetState createState() => new _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  TextEditingController tc = new TextEditingController();
  bool _isTyping = false;
  double _value = 1.0;
  List<String> imp = [
    "Barely",
    "Very Less",
    "Less",
    "Moderate",
    "Medium",
    "High",
    "Very High",
    "Very Very High",
    "Extreme"
  ];
  String importance = "Barely";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new TextField(
            controller: tc,
            onChanged: (String messageText) {
              setState(() {
                _isTyping = messageText.length > 0;
                addToMyCriteria();
              });
            },
            style: new TextStyle(color: Colors.black87, fontSize: 12.0),
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                labelText: "Criteria " + (widget.index + 1).toString()),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 5.0),
            child: new Text("Importance: " + importance,
                style: new TextStyle(
                    fontSize: 10.0, color: Theme.of(context).accentColor)),
          ),
          new Slider(
            label: _value.round().toString(),
            min: 1.0,
            max: 9.0,
            divisions: 10,
            value: _value,
            onChanged: (double value) {
              setState(() {
                _value = value;
                switch (value.round()) {
                  case 1:
                    importance = imp[0];
                    break;
                  case 2:
                    importance = imp[1];
                    break;
                  case 3:
                    importance = imp[2];
                    break;
                  case 4:
                    importance = imp[3];
                    break;
                  case 5:
                    importance = imp[4];
                    break;
                  case 6:
                    importance = imp[5];
                    break;
                  case 7:
                    importance = imp[6];
                    break;
                  case 8:
                    importance = imp[7];
                    break;
                  case 9:
                    importance = imp[8];
                    break;
                  default:
                    break;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void addToMyCriteria() {
    if (_isTyping == true) {
      myCriteria[widget.index] = tc.text;
      print(myCriteria.toString());
    }
  }
}
