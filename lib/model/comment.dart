import 'package:date_format/date_format.dart';

class CommentModel {
  String avatar; // 头像
  String nick; // 昵称
  String context; // 评论内容
  String createTime; // 评论时间
  int pariseNum; // 点赞数

  CommentModel({
    this.avatar,
    this.nick,
    this.context,
    this.createTime,
    this.pariseNum,
  });

  static readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp*1000);
    var diff = date.difference(now);

    return formatDate(date, [yyyy, '-', mm, '-', dd,' ',HH, ':', nn, ':', ss]);
  }

  CommentModel.fromJson(Map<String, dynamic> json)
      : avatar = json['avatarurl'].toString(),
        nick = json['nick'].toString(),
        context = json['rootcommentcontent'],
        pariseNum = json['praisenum'],
        createTime = readTimestamp(json['time']);
}
