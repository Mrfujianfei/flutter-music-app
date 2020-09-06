import 'package:flutter/material.dart';
import 'package:musicapp/model/comment.dart';

class Comment extends StatelessWidget {
  CommentModel model;
  bool isLast;
  Comment(this.model, {this.isLast = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 40.0,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(model.avatar),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            model.nick,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                          ),
                          Row(
                            children: <Widget>[
                              Text("${model.pariseNum}"),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                size: 18.0,
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 20, 8),
                        child: Text(
                          model.context,
                        ),
                      ),
                      Text(
                        model.createTime,
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 65.0, top: 5.0),
          child: Offstage(
            offstage: isLast,
            child: Divider(
              height: 0.5,
              color: Colors.grey[400],
            ),
          ),
        )
      ],
    );
  }
}
