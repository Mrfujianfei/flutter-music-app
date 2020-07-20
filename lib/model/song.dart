class Song {
  int id; // 歌曲id
  String name; // 歌曲名称
  String artists; // 演唱者
  String picUrl; // 歌曲图片
  String playUrl;
  Song(this.id, {this.name, this.artists, this.picUrl, this.playUrl});

  setPlayUrl(String url){
    this.playUrl = url;
  }

  @override
  String toString() {
    return 'Song{id: $id, name: $name, artists: $artists}';
  }
}
