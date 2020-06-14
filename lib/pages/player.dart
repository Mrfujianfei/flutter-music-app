import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AudioPlayer audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    print("重新初始化");
    // TODO: implement initState
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setUrl(
        "http://122.226.161.16/amobile.music.tc.qq.com/C400002202B43Cq4V4.m4a?guid=2796982635&vkey=1ADD4D0228DA995935E1042B20EAEA54E31CE47DCD43FEE34E41C59BCF3894D4D80447935D8ED972AAB8AB7FEFEBB0A1B4345E763DCB010C&uin=1899&fromtag=66");
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    audioPlayer.release();
    print("这是个什么生命周期");
  }

  play() {
    print(isPlaying);
    // 正在播放中
    if (isPlaying) {
      audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      audioPlayer.resume();
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.red),
      child: Center(
        child: Column(
          children: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("fanhui")),
            FlatButton(
                onPressed: () {
                  play();
                },
                child: Icon(Icons.play_circle_outline)),
          ],
        ),
      ),
    );
  }
}
