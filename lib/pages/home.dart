import 'package:flutter/material.dart';
import 'package:musicapp/pages/my_listen.dart';
import 'package:musicapp/pages/recommend.dart';
import 'package:musicapp/widgets/calendar_today.dart';
import 'package:musicapp/widgets/tab_view.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabView(
        tabMenus: <Widget>[
          CalendarToday(
            day:DateTime.now().day.toString() ,
          ),
          Icon(Icons.music_note,size:38.0,),
        ],
        children: <Widget>[
          Recommend(),
          MyListen(),
        ],
      ),
    );
  }
}
