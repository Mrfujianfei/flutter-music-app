import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/api/api.dart';
import 'package:musicapp/model/song.dart';
import 'package:musicapp/provider/music_model.dart';
import 'package:musicapp/widgets/comment_container.dart';
import 'package:musicapp/widgets/comment_list.dart';
import 'package:musicapp/widgets/popup.dart';
import 'package:musicapp/widgets/record.dart';
import 'package:musicapp/widgets/icon_switch_animated.dart';
import 'package:musicapp/widgets/tab_view.dart';
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
  // ignore: close_sinks
  StreamController<Duration> _streamController;
  TextStyle _timeStyle = TextStyle(fontSize: 10.0, color: Colors.grey);
  IconData _playStatusIcon = Icons.play_arrow;
  AnimationController _recordController;
  MusicProviderModel provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    provider = Provider.of<MusicProviderModel>(context, listen: false);

    // // 暂停播放上一首
    provider.pausePlay();

    // 初始化streamController
    _streamController = provider.constructStream();

    // 播放图标
    _playStatusIcon = provider.audioPlayer.state == AudioPlayerState.PAUSED
        ? Icons.play_arrow
        : Icons.pause;

    // 旋转图片控制器
    _recordController =
        new AnimationController(duration: Duration(seconds: 30), vsync: this);

    _recordController.repeat();
  }

  _showComment(ctx, id) {
    showModalBottomWidget(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CommonentContainer(ctx, id);
      },
    );
  }

  _getPlayTypeIconData(type) {
    switch (type) {
      case PLAY_TYPE.ORDER_LIST:
        return Icons.cached;
      case PLAY_TYPE.SING_ONE:
        return Icons.details;
      case PLAY_TYPE.RANDOM_LIST:
        return Icons.all_inclusive;
    }
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
            Consumer<MusicProviderModel>(builder: (context, model, child) {
              return SizedBox(
                height: 240.0,
                width: 240.0,
                child: AnimatedRecord(
                  controller: _recordController,
                  url: model.curSong.picUrl,
                ),
              );
            }),
            SizedBox(
              // 占位
              height: 140.0,
            ),
            StreamBuilder<Duration>(
              stream: _streamController.stream,
              initialData: Duration(),
              builder: (context, snapshot) {
                return Container(
                  // height: 100.0,
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  width: double.maxFinite,
                  child: Consumer<MusicProviderModel>(
                    builder: (context, model, child) {
                      return Row(
                        children: <Widget>[
                          // 时间裁剪
                          Text(
                            snapshot.data.toString().substring(0, 7),
                            style: _timeStyle,
                          ),
                          Expanded(
                              child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              overlayColor: Color.fromRGBO(255, 255, 255, 0.4),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 8.0),
                              thumbShape: RoundSliderThumbShape(
                                //可继承SliderComponentShape自定义形状
                                enabledThumbRadius: 4, //滑块大小
                              ),
                            ),
                            child: Slider(
                              value: snapshot.data.inMilliseconds.toDouble(),
                              min: 0.0,
                              max: model.currentSongDur.inMilliseconds
                                  .toDouble(),
                              inactiveColor: Colors.grey[350],
                              // overlayColor:Colors.blue[50],
                              onChangeStart: (val) {
                                model.pausePlay();
                              },
                              onChanged: (val) {
                                _streamController.sink
                                    .add(Duration(milliseconds: val.toInt()));
                              },
                              onChangeEnd: (val) {
                                model.seekPlay(val.toInt());
                              },
                            ),
                          )),
                          Text(
                            model.currentSongDur.toString().substring(0, 7),
                            style: _timeStyle,
                          )
                        ],
                      );
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _showComment(context, provider.curSong.id);
                    },
                    child: Icon(Icons.comment, size: 30.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('播放顺序');
                    },
                    child: Consumer<MusicProviderModel>(
                      builder: (context, model, child) {
                        return IconSwitchAnimated(
                          icon: _getPlayTypeIconData(model.playType),
                          iconSize: 40.0,
                          color: Colors.black,
                          onTap: () {
                            provider.switchPlayType();
                          },
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.prewPlay();
                    },
                    child: Icon(Icons.skip_previous, size: 40.0),
                  ),
                  Container(
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
                    child: Consumer<MusicProviderModel>(
                        builder: (context, model, child) {
                      return IconSwitchAnimated(
                        icon: _playStatusIcon,
                        iconSize: 40.0,
                        onTap: () {
                          setState(() {
                            if (_playStatusIcon == Icons.play_arrow) {
                              model.resume();
                              _playStatusIcon = Icons.pause;
                              _recordController.repeat();
                            } else {
                              model.pause();
                              _playStatusIcon = Icons.play_arrow;
                              _recordController.stop();
                            }
                          });
                        },
                      );
                    }),
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.nextPlay();
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
