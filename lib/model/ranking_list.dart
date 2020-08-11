class RankList {
  final String label;
  final int listenNum;
  final String period;
  final String picUrl;
  final int topId;
  final String updateTime;
  final int value;

  RankList(this.label, this.listenNum, this.period, this.picUrl, this.topId,
      this.updateTime, this.value);

  RankList.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        listenNum = json['listenNum'],
        period = json['period'],
        picUrl = json['picUrl'],
        topId = json['topId'],
        updateTime = json['updateTime'],
        value = json['value'];

  Map<String, dynamic> toJson() => {
        'label': label,
        'listenNum': listenNum,
        'period': period,
        'picUrl': picUrl,
        'topId': topId,
        'updateTime': updateTime,
        'value': value,
      };
}

class RankDetail {
  final int id;
  final String singerName;
  final String timePublic;
  final String name;
  final String mid;
  final String duration;

  RankDetail(this.id, this.singerName, this.timePublic, this.name, this.mid,
      this.duration);

   static _getDuration(int interval){
    String min = (interval~/60).toString(); // 分钟
    String sec =(interval%60).toString(); // 秒
    return (min.length<2?'0'+min:min) +':'+ (sec.length<2?'0'+sec:sec);
  }

  RankDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        singerName = json['singerName'],
        timePublic = json['time_public'],
        name = json['name'],
        mid = json['mid'],
        duration = _getDuration(json['interval']);
}