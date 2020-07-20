import 'package:musicapp/model/ranking_list.dart';
import 'package:musicapp/model/recommend_list.dart';
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
    print(response);
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
    return list;
  }

  /**
   * 获取榜单详情
   * id: 默认 4，从getRankingList的列表中取值
   * period:  榜单的时间，从上面的列表中取值，非必填
   * pageSize: 默认 100 // 部分接口不支持这个字段，所以这里默认选择100
   * time:  默认当前时间，如果有 period，此参数无效
   */
  static Future<List<RankDetail>> getRankingDetail(Map<String, dynamic> params) async {
    var response = await _net.get('/top', params);
    List<RankDetail> list = [];
    if (response.data != null) {
      response.data['data']['list'].map((item) {
        list.add(RankDetail.fromJson(item));
      }).toList();
    }
    return list;
  }

   /**
   * 获取播放连接
   * id: 歌曲的 songmid，必填，多个用逗号分割，该接口可用 post 或 get
   */
  static Future<Map<String, dynamic>> getPlayerUrl(Map<String, dynamic> params) async {
    var response = await _net.get('/song/urls?id=${params['id']}', {});
    return response.data;
  }
}
