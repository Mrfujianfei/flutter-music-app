import 'package:musicapp/model/recommend_list.dart';
import 'package:musicapp/units/net_units.dart';

class Api{

  static NetUnits _net = NetUnits.getInstance();

  /**
   * 获取音乐推荐列表
   * id: 分类id，默认为 3317 // 3317: 官方歌单，59：经典，71：情歌，3056：网络歌曲，64：KTV热歌
   * pageNo: 页码，默认为 1
   * pageSize: 每页返回数量，默认为 20
   */
  static Future<RecommendList> getRecommendList (Map<String, dynamic> params) async {

    var response = await _net.get('http://192.168.18.186:3300/song/urls',{
       "id":"0029Trp4461bN9"
    });
    print(response);
    return RecommendList.fromJson(response.data);
  } 

}