import 'package:musicapp/model/comment.dart';
import 'package:musicapp/model/lyerics.dart';
import 'package:musicapp/model/ranking_list.dart';
import 'package:musicapp/model/recommend_list.dart';
import 'package:musicapp/model/song.dart';
import 'package:musicapp/units/net_units.dart';

class Api {
  static NetUnits _net = NetUnits.getInstance();

  /**
   * 获取音乐推荐列表
   * id: 分类id，默认为 3317 // 3317: 官方歌单，59：经典，71：情歌，3056：网络歌曲，64：KTV热歌
   * pageNo: 页码，默认为 1
   * pageSize: 每页返回数量，默认为 20
   */
  static Future<RecommendList> getRecommendList(
      Map<String, dynamic> params) async {
    var response = await _net
        .get('http://192.168.18.186:3300/song/urls', {"id": "0029Trp4461bN9"});
    return RecommendList.fromJson(response.data);
  }

  /**
   * 获取榜单列表
   */
  static Future<List<RankList>> getRankingList() async {
    var response = await _net.get('/top/category', {});
    List<RankList> list = [];
    if (response.data != null) {
      response.data['data'][0]['list'].map((item) {
        list.add(RankList.fromJson(item));
      }).toList();
    }
    return []; // list;
  }

  /**
   * 获取榜单详情
   * id: 默认 4，从getRankingList的列表中取值
   * period:  榜单的时间，从上面的列表中取值，非必填
   * pageSize: 默认 100 // 部分接口不支持这个字段，所以这里默认选择100
   * time:  默认当前时间，如果有 period，此参数无效
   */
  static Future<List<RankDetail>> getRankingDetail(
      Map<String, dynamic> params) async {
    var response = await _net.get('/top', params);
    List<RankDetail> list = [];
    if (response.data != null) {
      response.data['data']['list'].map((item) {
        list.add(RankDetail.fromJson(item));
      }).toList();
    }
    return []; //list;
  }

  /**
   * 获取播放连接
   * id: 歌曲的 songmid，必填，多个用逗号分割，该接口可用 post 或 get
   */
  static Future<Map<String, dynamic>> getPlayerUrl(
      Map<String, dynamic> params) async {
    var response = await _net.get('/song/urls?id=${params['id']}', {});
    return response.data;
  }

  /**
   * 获取歌词
   * id: 歌曲的 songmid，必填，多个用逗号分割，该接口可用 post 或 get
   */
  static Future<Map<String, dynamic>> getLyerics(String songmid) async {
    var response = await _net.get('/lyric?songmid=${songmid}', {});
    return response.data;
  }

  /**
   * 搜索歌曲
   * key ：关键字
   * pageNo: 分页符
   * pageSize：每页条数
   * t： 0：单曲，2：歌单，7：歌词，8：专辑，9：歌手，12：mv
   */
  static Future<List<Song>> doSearch(Map<String, dynamic> params) async {
    var response = await _net.get('/search', params);
    var result = response.data;
    List<Song> _list = [];
    result['data']['list'].forEach((item) {
      print(item.toString());
      _list.add(Song.fromJson(item));
    });
    return _list;
  }

  /**
   * 搜索歌曲
   * key ：关键字
   * pageNo: 分页符
   * pageSize：每页条数
   * t： 0：单曲，2：歌单，7：歌词，8：专辑，9：歌手，12：mv
   */
  static Future<Map<String, dynamic>> getCommentList(
      Map<String, dynamic> params) async {
    var response =
        await _net.get('/comment', {"type": 1, "biztype": 1, ...params});
    var result = response.data;
    List<CommentModel> _list = [];
    // qq评论
    if (params['origin'] == 0 &&result['comment']['commentlist']!=null) {
      result['comment']['commentlist'].forEach((item) {
        _list.add(CommentModel.fromJson(item));
      });
    }
    // 网易云评论
    if (params['origin'] == 1) {
      result['body']['hotComments'].forEach((item) {
        _list.add(CommentModel.fromJson({
          "avatarurl": item['user']['avatarUrl'],
          "nick": item['user']['nickname'],
          "rootcommentcontent": item['content'],
          "praisenum": item['likedCount'],
          "time": item['time']
        }));
      });
    }
    return {
      "list": _list,
      "songId": params['origin'] == 1 ? result['songId'] : null
    };
  }
}
