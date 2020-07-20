import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/api/api.dart';
import 'package:musicapp/model/song.dart';
import 'package:musicapp/provider/music_model.dart';
import 'package:provider/provider.dart';

class Player extends StatefulWidget {
  String mid;
  Player({this.mid});
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  bool isPlaying = false;
  bool loading = false;

  @override
  void initState() {
    print(widget.mid);
    // TODO: implement initState
    super.initState();
    _getPlayUrl();  
    // audioPlayer.setUrl(
    //     "http://122.226.161.16/amobile.music.tc.qq.com/C400002202B43Cq4V4.m4a?guid=2796982635&vkey=1ADD4D0228DA995935E1042B20EAEA54E31CE47DCD43FEE34E41C59BCF3894D4D80447935D8ED972AAB8AB7FEFEBB0A1B4345E763DCB010C&uin=1899&fromtag=66");
  }

  Future _getPlayUrl() async {
    setState(() {
      loading = true;
    });
    // 获取播放连接
    var result = await Api.getPlayerUrl({"id": widget.mid});
    setState(() {
      loading = false;
    });
    print(result['data'][widget.mid]);
    // 设置播放连接
    // audioPlayer.setUrl(result['data'][widget.mid]);
    Provider.of<MusicProviderModel>(context,listen: false).playSong(Song(1,
          name:"歌曲1",
          artists:"无名",
          picUrl: '',
          playUrl: result['data'][widget.mid]
    ));
    setState(() {
      loading = false;
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("这是个什么生命周期");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.red),
      child: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("${loading}")),
            FlatButton(
                onPressed: () {
                  print('111111');
                  Provider.of<MusicProviderModel>(context,listen: false).togglePlay();
                },
                child: Icon(Icons.play_circle_outline)),
          ],
        ),
      ),
    );
  }
}
