import 'package:flutter/material.dart';
import 'package:musicapp/model/music.dart';
import 'package:musicapp/widgets/music_list_item.dart';

class MyListen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> _list = [];
    for (var i = 0; i < 20; i++) {
      _list.add(MusicListItem(
        data: MusicLabel(
          index: i + 1,
          name: "歌名${i}",
          author: "作者${i}",
          isPlay: i == 5 ? true : false,
        ),
      ));
    }
    return ListView(
      padding: EdgeInsets.only(top: 10.0),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: _list,
          ),
        )
      ],
    );
  }
}