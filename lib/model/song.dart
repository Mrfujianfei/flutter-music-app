class Song {
  String id; // 歌曲id
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

  static _getDuration(int interval) {
    String min = (interval ~/ 60).toString(); // 分钟
    String sec = (interval % 60).toString(); // 秒
    return (min.length < 2 ? '0' + min : min) +
        ':' +
        (sec.length < 2 ? '0' + sec : sec);
  }

  Song.fromJson(Map<String, dynamic> json)
      : id = json['id']!=null ? int.parse(json['id']) : json['songmid'],
        mid = json['songmid'].toString(),
        albumId = json['albumId'].toString(),
        name = json['songname'],
        singer = json['singer'][0]['name'],
        picUrl = "https://y.gtimg.cn/music/photo_new/T002R300x300M000${json['albummid']}.jpg",
        playUrl ="",
        addTime = null,
        duration = _getDuration(json['interval']),
        ablbumName = json['albumname'];

  @override
  String toString() {
    return 'Song{id: $id,mid:$mid,singer:$singer,playUrl:$playUrl, name: $name, artists: $singer}';
  }
}
