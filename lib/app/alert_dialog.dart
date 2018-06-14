import 'package:flutter/material.dart';
import 'package:girlies/app/button.dart';

class CustomAlertDialog extends StatelessWidget {
  final double borderRadius;
  final String text;
  final String btnText;
  final String setTitle;
  final String setMessage;
  final VoidCallback onDismiss;
  final VoidCallback onProceed;

  CustomAlertDialog({
    Key key,
    this.borderRadius = 10.0,
    this.text,
    this.setTitle,
    this.setMessage,
    this.onDismiss,
    this.onProceed,
    this.btnText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new AlertDialog(
      title: new Text(setTitle),
      content: new Text(setMessage),
      actions: <Widget>[
        new CustomButton(
          setTopMargin: 5.0,
          setBottomMargin: 10.0,
          setLeftMargin: 10.0,
          setrightMargin: 10.0,
          setBtnWidth: 150.0,
          setBtnHeight: 40.0,
          setBtnRaduis: 25.0,
          setBtnColor: Colors.pink[900],
          setBtnText: btnText == null ? 'Proceed' : btnText,
          setBtnTextColor: Colors.white,
          onBtnClicked: onProceed,
        ),
      ],
    );
  }
}
