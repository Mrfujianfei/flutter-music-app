import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:musicapp/model/lyerics.dart';
import 'package:musicapp/provider/music_model.dart';
import 'package:musicapp/widgets/loading.dart';
import 'package:musicapp/widgets/nav_bar.dart';
import 'package:provider/provider.dart';

const double HEIGHT = 40.0;

class Lyerics extends StatefulWidget {
  @override
  _LyericsState createState() => _LyericsState();
}

class _LyericsState extends State<Lyerics>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Lyerics> {
  ScrollController _controller;
  double _top = 10.0;

  Duration _currentTime;
  double _scrollTop = 0.0;

  StreamController _stream;

  StreamSubscription _dataSubscription;

  // 歌词内容
  List<LyericsModel> _source = [];

  bool _touching = false;

  // http状态
  bool _loading = false;

  bool _isReachBottom = false;

  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentTime = new Duration(milliseconds: 0);

    // 初始化_controller内容
    _controller = new ScrollController();
    _controller.addListener(() {
      timer?.cancel();
      if (_touching) {
        timer = new Timer(Duration(milliseconds: 2000), () {
          _touching = false;
          timer = null;
        });
      }

      if (_isReachBottom ) {
        return;
      }

      setState(() {
        _scrollTop = _controller.offset;
      });
    });

    // 初始化streamController
    _stream = Provider.of<MusicProviderModel>(context, listen: false)
        .constructStream();

    // // 播放音乐
    // Provider.of<MusicProviderModel>(context, listen: false).play();

    // 加载歌词
    Provider.of<MusicProviderModel>(context, listen: false).loadLyerics();

    _stream.stream.listen((duratin) {
      _currentTime = duratin;
      _jumpToLine();
    });
  }

  _getStyle(LyericsModel model) {
    TextStyle _style = TextStyle(color: Colors.black, fontSize: 14.0);
    if (model == null) {
      return _style;
    }
    if (_currentTime.inMilliseconds >= model.startTime.inMilliseconds &&
        _currentTime.inMilliseconds < model.endTime.inMilliseconds) {
      _style = TextStyle(color: Colors.white, fontSize: 16.0);
    }

    if (_touching &&
        _scrollTop > model.top &&
        _scrollTop < model.top + HEIGHT) {
      _style = TextStyle(color: Colors.white60, fontSize: 14.0);
    }
    return _style;
  }

  _jumpToLine() {
    if (_touching || _source.length ==0) {
      return;
    }
    LyericsModel model = _source.firstWhere((item) {
      return _currentTime.inMilliseconds >= item.startTime.inMilliseconds &&
          _currentTime.inMilliseconds < item.endTime.inMilliseconds;
    });
    if (model != null && _controller.hasClients) {
      _controller.animateTo(model.top,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _isReachBottom = true;
    }
  }

  // 渲染歌词列表
  _rendList() {
    List<Widget> _list = _source.map((item) {
      return Container(
        height: HEIGHT,
        child: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 500),
          child: Text("${item.text}"),
          style: _getStyle(item),
        ),
      );
    }).toList();
    return _list;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _isReachBottom =true;
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(83, 105, 118, 1),
            Color.fromRGBO(83, 105, 118, 1),
            // Color.fromRGBO(187, 210, 197, 1),
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 0,
            child: NavBar(
              title: "占位",
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  Consumer<MusicProviderModel>(
                    builder: (context, model, child) {
                      return Offstage(
                        offstage: model.loadingLyerics,
                        child: GestureDetector(
                          onPanDown: (val) {
                            _touching = true;
                          },
                          child: SingleChildScrollView(
                            controller: _controller,
                            child: Consumer<MusicProviderModel>(
                              builder: (context, model, child) {
                                _source = model.lyericsList;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 300.0,
                                    ),
                                    ..._rendList(),
                                    SizedBox(
                                      height: 300.0,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    height: 120.0,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(83, 105, 118, 1),
                          Color.fromRGBO(83, 105, 118, 0.6),
                          Color.fromRGBO(83, 105, 118, 0.0),

                          // Color.fromRGBO(187, 210, 197, 1),
                        ],
                      ),
                    ),
                  ),
                  Consumer<MusicProviderModel>(
                    builder: (context, model, child) {
                      return Center(
                        child: Offstage(
                          offstage: !model.loadingLyerics,
                          child: Loading(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
