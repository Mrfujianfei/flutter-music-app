import 'package:flutter/material.dart';

// 旋转唱片
class AnimatedRecord extends StatefulWidget {
  AnimationController controller;
  String url;
  AnimatedRecord({this.controller, this.url});
  @override
  _AnimatedRecordState createState() => _AnimatedRecordState();
}

class _AnimatedRecordState extends State<AnimatedRecord> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(250.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 6.0),
            blurRadius: 10.0,
            spreadRadius: 1.0,
            color: Colors.black26,
          ),
        ],
      ),
      child: RotationTransition(
        turns: widget.controller,
        child: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: ClipOval(
            child: widget.url != ''
                ? Image.network(widget.url)
                : DecoratedBox(decoration: BoxDecoration(color: Colors.green)),
          ),
        ),
      ),
    );
  }
}
