import 'package:flutter/material.dart';

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
          Text("tab1"),
          Text("tab2"),
          Text("tab3"),
        ],
        children: <Widget>[
          Container(
            color: Colors.grey,
          ),
          Container(
            color: Colors.orange,
          ),
          Container(
            color: Colors.green,
          )
        ],
      ),
    );
  }
}
