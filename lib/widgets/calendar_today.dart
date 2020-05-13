import 'package:flutter/material.dart';
import 'package:musicapp/config.dart';
/**
 * 显示今日日期的ICON组件
 */
class CalendarToday extends StatelessWidget {
  String day;
  CalendarToday({this.day="00"});
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
          day,
          style: TextStyle(
              fontWeight: FontWeight.w700, color: themeColor, fontSize: 18.0),
        )
      ],
    );
  }
}
