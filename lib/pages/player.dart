import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/api/api.dart';
import 'package:musicapp/model/song.dart';
import 'package:musicapp/provider/music_model.dart';
import 'package:musicapp/widgets/record.dart';
import 'package:provider/provider.dart';

class Player extends StatefulWidget {
  String mid;
  Player({this.mid = ''});
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player>
    with AutomaticKeepAliveClientMixin<Player>, TickerProviderStateMixin {
  bool isPlaying = false;
  bool loading = false;
  String _str = '';
  StreamController<Duration> _streamController;
  TextStyle _timeStyle = TextStyle(fontSize: 10.0, color: Colors.grey);

  AnimationController _recordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // // // 暂停播放上一首
    // Provider.of<MusicProviderModel>(context, listen: false).pausePlay();

    // // 初始化streamController
    // _streamController = Provider.of<MusicProviderModel>(context, listen: false)
    //     .constructStream();

    // // 播放音乐
    Provider.of<MusicProviderModel>(context, listen: false).play();

    _recordController =
        new AnimationController(duration: Duration(seconds: 30), vsync: this);

    _recordController.repeat();
  }

  @override
  void dispose() {
    _recordController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(top: 100.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              // 占位
              height: 40.0,
            ),
            AnimatedRecord(
              controller: _recordController,
            ),
            SizedBox(
              // 占位
              height: 140.0,
            ),
            // StreamBuilder<Duration>(
            //   stream: _streamController.stream,
            //   initialData: Duration(),
            //   builder: (context, snapshot) {
            //     return Container(
            //       // height: 100.0,
            //       padding: EdgeInsets.symmetric(horizontal: 24.0),
            //       width: double.maxFinite,
            //       child: Consumer<MusicProviderModel>(
            //         builder: (context, model, child) {
            //           return Row(
            //             children: <Widget>[
            //               // 时间裁剪
            //               Text(
            //                 snapshot.data.toString().substring(0, 7),
            //                 style: _timeStyle,
            //               ),
            //               Expanded(
            //                   child: SliderTheme(
            //                 data: SliderTheme.of(context).copyWith(
            //                   overlayColor: Color.fromRGBO(255, 255, 255, 0.4),
            //                   overlayShape:
            //                       RoundSliderOverlayShape(overlayRadius: 8.0),
            //                   thumbShape: RoundSliderThumbShape(
            //                     //可继承SliderComponentShape自定义形状
            //                     enabledThumbRadius: 4, //滑块大小
            //                   ),
            //                 ),
            //                 child: Slider(
            //                   value: snapshot.data.inMilliseconds.toDouble(),
            //                   min: 0.0,
            //                   max: model.currentSongDur.inMilliseconds
            //                       .toDouble(),
            //                   inactiveColor: Colors.grey[350],
            //                   // overlayColor:Colors.blue[50],
            //                   onChangeStart: (val) {
            //                     model.pausePlay();
            //                   },
            //                   onChanged: (val) {
            //                     _streamController.sink
            //                         .add(Duration(milliseconds: val.toInt()));
            //                   },
            //                   onChangeEnd: (val) {
            //                     model.seekPlay(val.toInt());
            //                   },
            //                 ),
            //               )),
            //               Text(
            //                 model.currentSongDur.toString().substring(0, 7),
            //                 style: _timeStyle,
            //               )
            //             ],
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print('播放顺序');
                    },
                    child: Icon(Icons.sync, size: 30.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<MusicProviderModel>(context, listen: false)
                          .prewPlay();
                    },
                    child: Icon(Icons.skip_previous, size: 40.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<MusicProviderModel>(context, listen: false)
                          .togglePlay();
                      if (_recordController.isAnimating) {
                        _recordController.stop();
                      } else {
                        _recordController.repeat();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10.0,
                                spreadRadius: 1.0,
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                offset: Offset(0.0, 5.0))
                          ],
                          borderRadius: BorderRadius.circular(200.0)),
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Consumer<MusicProviderModel>(
                            builder: (context, model, child) {
                          return Icon(
                            model.audioPlayer.state == AudioPlayerState.PAUSED
                                ? Icons.play_arrow
                                : Icons.pause,
                            size: 40.0,
                          );
                        }),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<MusicProviderModel>(context, listen: false)
                          .nextPlay();
                    },
                    child: Icon(Icons.skip_next, size: 40.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('播放列表');
                    },
                    child: Icon(Icons.menu, size: 30.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
