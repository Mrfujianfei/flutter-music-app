import 'package:flutter/material.dart';

class MenuLable extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  MenuLable({this.icon, this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 15.0),
        onPressed: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 25.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ));
  }
}
