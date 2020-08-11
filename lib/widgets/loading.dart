import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String _text = "正在加载";

  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        if (_text.contains(".....")) {
          _text = "正在加载";
        } else {
          _text += '.';
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: <Color>[Colors.green[200], Colors.lime[500]],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Text(_text),
        );
    
    // Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     LoadingBumpingLine.square(
    //       // borderColor: Colors.red,
    //       borderSize: 10.0,
    //       size: 40.0,
    //       backgroundColor: Colors.green,
    //     ),
        
    //   ],
    // );
  }
}
