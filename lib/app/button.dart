import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Icon icon;
  final double setTopMargin;
  final double setBottomMargin;
  final double setrightMargin;
  final double setLeftMargin;
  final double setBtnHeight;
  final double setBtnWidth;
  final double setBtnRaduis;
  final String setBtnText;
  final Color setBtnColor, setBtnTextColor;
  final VoidCallback onBtnClicked;
  final Icon setBtnIcon;

  //final VoidCallback onTap;

  CustomButton(
      {this.setTopMargin,
      this.setBottomMargin,
      this.setrightMargin,
      this.setLeftMargin,
      this.setBtnRaduis,
      this.setBtnText,
      this.setBtnColor,
      this.setBtnTextColor,
      this.onBtnClicked,
      this.setBtnHeight,
      this.setBtnWidth,
      this.setBtnIcon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      width: setBtnWidth,
      height: setBtnHeight,
      margin: new EdgeInsets.only(
          bottom: setBottomMargin,
          top: setTopMargin,
          right: setrightMargin,
          left: setLeftMargin),
      decoration: new BoxDecoration(
          color: setBtnColor,
          borderRadius: new BorderRadius.all(Radius.circular(setBtnRaduis)),
          border: new Border.all(
            color: const Color.fromRGBO(221, 221, 221, 1.0),
          )),
      child: new RaisedButton(
        onPressed: onBtnClicked,
        color: setBtnColor,
        child: new Text(
          setBtnText,
          style: new TextStyle(
              fontSize: 15.0,
              color: setBtnTextColor,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
