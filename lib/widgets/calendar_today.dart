import 'package:flutter/material.dart';
import 'package:musicapp/config.dart';

class CalendarToday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(0, 0.5),
      children: <Widget>[
        Icon(
          Icons.calendar_today,
          size: 38.0,
        ),
        Text(
          "26",
          style: TextStyle(
              fontWeight: FontWeight.w700, color: themeColor, fontSize: 18.0),
        )
      ],
    );
  }
}
