import 'package:flutter/material.dart';

import 'package:musicapp/route/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'music app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // 消除右上角debug样式
      initialRoute: '/', // 初始化路由
      // routes: routes,
      onGenerateRoute: (RouteSettings settings) {
        print("=====");
        print(settings);
        return MaterialPageRoute(
          builder: routes[settings.name],
          settings: settings
        );
      },
      onUnknownRoute:(settings){
        print(settings);
      } ,
    );
  }
}


