import 'package:flutter/material.dart';
import 'package:musicapp/model/music.dart';
import 'package:musicapp/widgets/music_list_item.dart';
import 'package:musicapp/widgets/welcome.dart';

class Recommend extends StatelessWidget {
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
      children: <Widget>[
        Welcome(),
        FlatButton(onPressed: (){
          print("11");
          Navigator.of(context).pushNamed('/player');
        }, child: Text(
          "听歌"
        )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Text(
            "今日推荐·精选",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
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
