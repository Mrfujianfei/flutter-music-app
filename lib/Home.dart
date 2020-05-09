import 'package:flutter/material.dart';

import 'Home2.dart';
import 'pages/recommend.dart';
import 'widgets/calendar_today.dart';
import 'widgets/tab_view.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: TabView(
        tabMenus: <Widget>[
          CalendarToday(),
          Icon(Icons.music_note,size:38.0,),
        ],
        children: <Widget>[
          Recommend(),
          Home2(),
        ],
      ),
    );
  }
}
