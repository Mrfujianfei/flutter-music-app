import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0),
      padding: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.red),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "早上好，",
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Color.fromRGBO(43, 46, 74, 1),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "Good Morning~",
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Color.fromRGBO(43, 46, 74, 1),
                      fontWeight: FontWeight.w800),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: SizedBox(
              width: 100.0,
              height: 100.0,
              child: Center(
                child: new SvgPicture.asset(
                  "assets/sun.svg",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
