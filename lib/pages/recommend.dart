import 'package:flutter/material.dart';
import 'package:musicapp/widgets/welcome.dart';

class Recommend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Welcome(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0),
          child: Text(
            "今日推荐·精选",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[Text("data")],
          ),
        )
      ],
    );
  }
}
