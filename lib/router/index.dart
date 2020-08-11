import 'package:flutter/material.dart';
import 'package:musicapp/Home2.dart';
import 'package:musicapp/pages/home.dart';
import 'package:musicapp/pages/lyerics.dart';
import 'package:musicapp/pages/player.dart';
import 'package:musicapp/pages/playing_tab.dart';
import 'package:musicapp/pages/search.dart';

getRoutes(settings) {
  final Map<String, WidgetBuilder> routes = {
    '/': (context) => Home(),
    '/hom2': (context) => Home2(),
    '/player': (context) => Player(mid: settings.arguments['mid']),
    '/lyerics': (context) => Lyerics(),
    '/playingTabs': (context) => PlayingTab(),
    '/search': (context) => SearchPage()
  };
  return routes;
}
