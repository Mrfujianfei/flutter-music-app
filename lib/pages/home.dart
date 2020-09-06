import 'package:flutter/material.dart';
import 'package:musicapp/pages/my_listen.dart';
import 'package:musicapp/pages/recommend.dart';
import 'package:musicapp/widgets/calendar_today.dart';
import 'package:musicapp/widgets/menu_drawer.dart';
import 'package:musicapp/widgets/menu_label.dart';
import 'package:musicapp/widgets/play_sandbox.dart';
import 'package:musicapp/widgets/tab_view.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MenuDrawer(
            menu: Container(
              width: 200.0,
              padding: EdgeInsets.symmetric(
                vertical: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: ClipOval(
                      child: SizedBox(
                        height: 140.0,
                        width: 140.0,
                        child: Image.asset('assets/header.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MenuLable(
                    icon: Icons.toys,
                    text: "喜欢",
                    onTap: () {
                      print(11);
                    },
                  ),
                  MenuLable(
                    icon: Icons.settings_input_svideo,
                    text: "收藏",
                    onTap: () {
                      print(11);
                    },
                  ),
                  MenuLable(
                    icon: Icons.spa,
                    text: "关于",
                    onTap: () {
                      print(11);
                    },
                  ),
                  MenuLable(
                    icon: Icons.settings,
                    text: "设置",
                    onTap: () {
                      print(11);
                    },
                  )
                ],
              ),
            ),
            tabMenus: <Widget>[
              CalendarToday(
                day: DateTime.now().day.toString(),
              ),
              Icon(
                Icons.music_note,
                size: 38.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/search');
                },
                child: Icon(Icons.search),
              )
            ],
            children: <Widget>[
              Recommend(),
              MyListen(),
            ],
          ),
          PlaySandbox(),
        ],
      ),
    );
  }
}
