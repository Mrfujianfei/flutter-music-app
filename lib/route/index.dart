
import 'package:flutter/material.dart';

import '../Home.dart';
import '../Home2.dart';
final Map<String,WidgetBuilder> routes = {
  '/':(context)=>Home(),
  '/hom2':(context)=>Home2(),
  '/*':(context){
    return Container(
      child: Text("null"),
    );
  }
};

