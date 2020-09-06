import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:musicapp/api/api.dart';
import 'package:musicapp/model/lyerics.dart';
import 'package:musicapp/model/song.dart';
import 'package:musicapp/units/common_fun.dart';

enum PLAY_TYPE {
  ORDER_LIST, // 顺序播放
  SING_ONE, // 单曲循环
  RANDOM_LIST // 随机播放
}

class MusicProviderModel with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer; // 播放器实例

  List<Song> _playList = [];

  List<Song> get playList => _playList; // 播放列表

  AudioPlayerState _currentState;

  AudioPlayerState get currentState => _currentState; // 当前播放状态

  Duration _currentSongDur = new Duration();

  Duration get currentSongDur => _currentSongDur; // 当前歌曲的播放进度

  int _currentIndex = 0;

  int get currentIndex => _currentIndex; // 当前播放的下标，从0开始

  bool _loading = false;

  bool get loading => _loading; // 加载播放连接

  bool _loadingLyerics = false;

  bool get loadingLyerics => _loadingLyerics; // 加载歌词

  List<LyericsModel> _lyericsList = [];

  List<LyericsModel> get lyericsList => _lyericsList; // 歌词列表

  StreamController<Duration> _streamController;

  StreamController<Duration> get streamController => _streamController; // 控制器

  PLAY_TYPE _playType = PLAY_TYPE.ORDER_LIST;

  PLAY_TYPE get playType => _playType;

  Song get curSong => _playList.length == 0 ? null : _playList[_currentIndex];

  // 做一些初始化事件
  void init() {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    // 播放状态监听
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _currentState = state; // 先做顺序播放
      if (state == AudioPlayerState.COMPLETED) {
        nextPlay();
      }
      // notifyListeners();
    });
    // 当前播放进度监听
    _audioPlayer.onDurationChanged.listen((d) {
      _currentSongDur = d;
    });

    // 手动更新播放进度监听
    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      // seekPlay(p.inMilliseconds);
      streamController.sink.add(p);
    });

    _audioPlayer.onPlayerError.listen((msg) {
      print("==========error===========");
      print(msg);
    });
  }

  // 构造新的streamController对象
  StreamController constructStream() {
    _streamController = new StreamController<Duration>();
    return streamController;
  }

  // 切换播放顺序
  void switchPlayType() {
    switch (_playType) {
      case PLAY_TYPE.ORDER_LIST:
        _playType = PLAY_TYPE.SING_ONE;
        break;
      case PLAY_TYPE.SING_ONE:
        _playType = PLAY_TYPE.RANDOM_LIST;
        break;
      case PLAY_TYPE.RANDOM_LIST:
        _playType = PLAY_TYPE.ORDER_LIST;
        break;
    }
    notifyListeners();
  }

  // 播放一首歌
  void playSong(Song song) {
    this.addSongs([song]);
    _currentIndex = playList.length - 1;
    play();
  }

  // 播放多首歌
  void playSongs(List<Song> songs, {int index}) {
    _playList = songs;
    if (index != null) _currentIndex = index;
    play();
  }

  // 添加播放歌曲
  void addSongs(List<Song> songs) {
    songs.forEach((song) {
      int index = _playList.indexOf(song);
      if (index >= 0) {
        // 已经在列表中存在了
        print('---已经存在了----');
      } else {
        _playList.add(song);
      }
    });
    // _playList.addAll(songs);
  }

  // 播放
  void play() async {
    Song song = playList[_currentIndex];
    if (song.addTime == null) {
      song.setAddTime(new DateTime.now());
    }
    Duration diff = new DateTime.now().difference(song.addTime);

    // 加载歌词
    // loadLyerics();
    // 是否有播放连接,连接设置超过24小时重新获取
    if ((isEmpty(song.playUrl) && (!song.disabled)) || diff.inHours >= 24) {
      _loading = true;
      var result = await Api.getPlayerUrl({"id": song.mid});
      if (result['data'][song.mid] != null) {
        song.setPlayUrl(result['data'][song.mid]);
      } else {
        song.setDisabled(true);
      }
      _loading = false;
    }

    if (song.playUrl != '') {
      _audioPlayer.play(song.playUrl);
    } else {
      nextPlay();
    }
    notifyListeners();
  }

  void loadLyerics() async {
    Song song = playList[_currentIndex];
    _loadingLyerics = true;
    // 请求歌词
    var result = await Api.getLyerics(song.mid);
    RegExp expTime = new RegExp(r"(\[0.{7}\])");
    double HEIGHT = 0;
    // 对歌词数据进行处理
    List<String> list = result['data']['lyric'].split('\n');

    list = list.where((item) {
      return expTime.hasMatch(item);
    }).toList();

    print(list);

    List<LyericsModel> _firstList = list.where((item) {
      return item.substring(10) != '';
    }).map((item) {
      // 分钟
      int min = int.parse(item.substring(1, 3));
      // 秒钟
      int sec = int.parse(item.substring(4, 6));
      // 毫秒
      int mill = int.parse(item.substring(7, 9));
      LyericsModel model = LyericsModel(
        top: HEIGHT,
        startTime: Duration(
            days: 0, hours: 0, minutes: min, seconds: sec, milliseconds: mill),
        text: item.substring(10),
      );
      HEIGHT += 40;
      return model;
    }).toList();

    for (var i = 0; i < _firstList.length; i++) {
      Duration _endTime;
      if (i < _firstList.length - 1) {
        _endTime = _firstList[i + 1].startTime;
      } else {
        _endTime = currentSongDur;
      }
      _firstList[i].endTime = _endTime;
    }

    _lyericsList = _firstList;

    _loadingLyerics = false;

    // 通知更新
    notifyListeners();
  }

  // 播放下一首
  void nextPlay() {
    print(_playType);
    switch (_playType) {
      case PLAY_TYPE.ORDER_LIST:
        // 非最后一首歌的时候
        if (_currentIndex < playList.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0;
        }
        break;
      case PLAY_TYPE.SING_ONE:
        break;
      case PLAY_TYPE.RANDOM_LIST:
        // 当歌曲列表大于2个的时候
        if (_playList.length >= 2) {
          _currentIndex = _getRandomIndex();
        }
        break;
    }
    print(_currentIndex);
    play();
  }

  // 获取列表随机Index
  int _getRandomIndex() {
    int _index = Random().nextInt(playList.length);
    if (_index == _currentIndex) {
      _index = _getRandomIndex();
    }
    return _index;
  }

  // 上一首
  void prewPlay() {
    // 非第一首歌
    if (_currentIndex > 0) {
      _currentIndex--;
    } else {
      _currentIndex = playList.length - 1;
    }
    play();
  }

  // 暂停、恢复
  void togglePlay() {
    // 当前状态为暂停的时候开始播放
    if (_audioPlayer.state == AudioPlayerState.PAUSED) {
      audioPlayer.resume();
    } else {
      audioPlayer.pause();
    }

    notifyListeners();
  }

  // 恢复
  void resume() {
    audioPlayer.resume();
    notifyListeners();
  }

  // 暂停
  void pause() {
    audioPlayer.pause();
    notifyListeners();
  }

  // 进度跳转
  void seekPlay(int milliseconds) {
    _audioPlayer.seek(Duration(milliseconds: milliseconds));
    this.resumePlay();
  }

  // 暂停播放
  void pausePlay() {
    audioPlayer.pause();
  }

  // 继续播放
  void resumePlay() {
    audioPlayer.resume();
  }
}
