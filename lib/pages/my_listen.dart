import 'package:flutter/material.dart';
import 'package:musicapp/model/music.dart';
import 'package:musicapp/model/song.dart';
import 'package:musicapp/units/database_helper.dart';
import 'package:musicapp/widgets/music_list_item.dart';

class MyListen extends StatefulWidget {
  @override
  _MyListenState createState() => _MyListenState();
}

class _MyListenState extends State<MyListen> {

  List<Widget> children = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  insert() async{
    var db = DatabaseHelper();
    Song song =Song("23424",
      mid: "sdf23424",
      name:'mindf',
      singer: "歌手",
      picUrl: 'http://sdfsdfsfa',
      playUrl: 'http://df22234234',
      addTime:  DateTime.now(),
      albumId: '234',
      ablbumName: "grgasfw2",
      duration: "04:23",
      disabled: false
    );
    await db.insertSong(song);
    // db.close();
    print("新增成功");
  }

  getData() async{
    var db = DatabaseHelper();
    List<Song> list = await db.selectSongs(
      limit: 100,
      offset: 0
    );
    print(list);

    for(var i = 0 ; i < list.length ; i++ ){
      children.add(MusicListItem(
          data: MusicLabel(
              index: i+1,
              name: list[i].name,
              author: list[i].singer,
              isPlay: false,
              duration: list[i].duration),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 10.0),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              FlatButton(onPressed: (){
                insert();
              }, child: Text("新增")),
              FlatButton(onPressed: (){
                getData();
              }, child: Text("获取")),
              ...children
            ]
          ),
        )
      ],
    );
  }
}