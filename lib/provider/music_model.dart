import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:musicapp/model/song.dart';

class MusicProviderModel with ChangeNotifier {
  AudioPlayer _audioPlayer =AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer; // 播放器实例

  List<Song> _playList = [];

  List<Song> get playList => _playList; // 播放列表

  AudioPlayerState _currentState;

  AudioPlayerState get currentState => _currentState; // 当前播放状态

  Duration _currentSongDur ;

  Duration get currentSongDur => _currentSongDur; // 当前歌曲的播放进度

  int _currentIndex = 0;

  int get currentIndex => _currentIndex; // 当前播放的下标，从0开始

  // 做一些初始化事件
  void init() {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    // 播放状态监听
    _audioPlayer.onPlayerStateChanged.listen((state) {
      print('------1');
      print(state);
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
    });
  }

  // 播放一首歌
  void playSong(Song song) {
    _playList.add(song);
    _currentIndex = _playList.length-1;
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
    _playList.addAll(songs);
  }

  // 播放
  void play() {
    _audioPlayer.play(playList[_currentIndex].playUrl);
  }

  // 播放下一首
  void nextPlay() {
    // 非最后一首歌的时候
    if (_currentIndex < playList.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
    play();
  }

  // 上一首
  void prewPlay(){
    // 非第一首歌  
    if(_currentIndex>0){
      _currentIndex--;
    }else{
      _currentIndex = playList.length-1;
    }
    play();
  }


  // 暂停、恢复
  void togglePlay() {
    // 当前状态为暂停的时候开始播放
    if (_audioPlayer.state == AudioPlayerState.PAUSED) {
      _audioPlayer.resume();
    } else {
      _audioPlayer.pause();
    }
  }

  // 进度跳转
  void seekPlay(int milliseconds) {
    _audioPlayer.seek(Duration(milliseconds: milliseconds));
    togglePlay();
  }
}
