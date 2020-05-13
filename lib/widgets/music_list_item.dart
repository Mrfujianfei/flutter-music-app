import 'package:flutter/material.dart';
import 'package:musicapp/model/music.dart';

class MusicListItem extends StatelessWidget {
  MusicLabel data;
  MusicListItem({this.data});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 30.0, 10.0),
          child: Text(
            "${data.index}",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.name,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  data.author,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 10.0),
          child: Offstage(
            offstage: !data.isPlay,
            child: Icon(Icons.assessment),
          ),
        ),
      ],
    );
  }
}
