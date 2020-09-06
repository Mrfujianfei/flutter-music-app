import 'package:flutter/material.dart';

import 'comment_list.dart';

class CommonentContainer extends StatefulWidget {
  BuildContext ctx;
  String id;
  CommonentContainer(this.ctx, this.id);
  @override
  _CommonentContainerState createState() => _CommonentContainerState();
}

class _CommonentContainerState extends State<CommonentContainer> {
  String _origin = "QQ音乐";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            )),
        height: 500.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "评论",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  // todo_lks
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 1000),
                    child: Text(_origin),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        child: child,
                        opacity: animation,
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(widget.ctx).pop();
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  _origin = value == 0 ? "QQ音乐" : "网易云音乐";
                  setState(() {});
                },
                children: <Widget>[
                  CommentList(
                    widget.id,
                    origin: 0,
                  ),
                  CommentList(
                    widget.id,
                    origin: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print("1231231");
      },
    );
  }
}
