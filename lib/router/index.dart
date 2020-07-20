
import 'package:flutter/material.dart';
import 'package:musicapp/Home2.dart';
import 'package:musicapp/pages/home.dart';
import 'package:musicapp/pages/player.dart';


getRoutes(settings){
  final Map<String,WidgetBuilder> routes = {
    '/':(context)=>Home(),
    '/hom2':(context)=>Home2(),
    '/player':(context)=>Player(mid: settings.arguments['mid']) 
  };
  return routes;
}

