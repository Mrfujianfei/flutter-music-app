import 'package:flutter/material.dart';
import 'package:musicapp/provider/music_model.dart';
import 'package:musicapp/router/index.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicProviderModel()..init()),
      ],
      child: MyApp(),
    ),
  );
}

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
        return MaterialPageRoute(
            builder: getRoutes(settings)[settings.name], settings: settings);
      },
      onUnknownRoute: (settings) {
        print(settings);
      },
    );
  }
}
