class Song {
  int id; // 歌曲id
  String mid; // 歌曲的mid
  String albumId; // 专辑id
  String name; // 歌曲名称
  String singer; // 演唱者
  String picUrl; // 歌曲图片
  String playUrl; // 播放连接
  DateTime addTime; // 添加时间
  String duration; // 歌曲时长
  String ablbumName; // 专辑名称

  Song(
    this.id, {
    this.mid,
    this.name,
    this.singer,
    this.picUrl,
    this.playUrl = '',
    this.addTime,
    this.albumId,
    this.ablbumName,
    this.duration,
  });

  setPlayUrl(String url) {
    this.playUrl = url;
  }

  @override
  String toString() {
    return 'Song{id: $id,mid:$mid,singer:$singer,playUrl:$playUrl, name: $name, artists: $singer}';
  }
}
