import 'package:flutter/material.dart';


class ProgressBar extends StatelessWidget {

   final Color backgroundColor;
  final Color color;
  final Color containerColor;
  final double borderRadius;
  final String text;
  //final VoidCallback onTap;

   ProgressBar(
      {Key key,
      this.backgroundColor = Colors.black54,
      this.color = Colors.white,
      this.containerColor = Colors.transparent,
      this.borderRadius = 10.0,
      this.text
      }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: backgroundColor,
        body: new Stack(
          children: <Widget>[
            new Center(
              child: new Container(
                width: 150.0,
                height: 150.0,
                decoration: new BoxDecoration(
                    color: containerColor,
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(borderRadius))),
              ),
            ),
            new Center(
              child: _getCenterContent(),
            )
          ],
        ));
  }

 Widget _getCenterContent() {
    if (text == null || text.isEmpty) {
      return _getCircularProgress();
    }

    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getCircularProgress(),
          new Container(
            margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            child: new Text(
              text,
              style: new TextStyle(color: color),
            ),
          )
        ],
      ),
    );
  }

  Widget _getCircularProgress() {
    return new CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation(color));
  }


}


