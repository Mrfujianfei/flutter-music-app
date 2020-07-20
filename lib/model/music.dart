class MusicLabel{
  int index; // 序号
  String name; // 歌名
  String author; // 作者
  bool isPlay; // 是否正在播放
  String duration;
  MusicLabel({
    this.index,
    this.name,
    this.author,
    this.isPlay =false,
    this.duration
  });
}