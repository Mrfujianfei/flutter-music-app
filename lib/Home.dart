import 'package:flutter/material.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed('/hom3');
          },
          child: Text("首页"),
        ),
      ),
    );
  }
}