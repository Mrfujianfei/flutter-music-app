import 'package:flutter/material.dart';
import 'package:musicapp/api/api.dart';
import 'package:musicapp/model/music.dart';
import 'package:musicapp/model/ranking_list.dart';
import 'package:musicapp/model/recommend_list.dart';
import 'package:musicapp/model/song.dart';
import 'package:musicapp/provider/music_model.dart';
import 'package:musicapp/widgets/music_list_item.dart';
import 'package:musicapp/widgets/welcome.dart';
import 'package:provider/provider.dart';

class Recommend extends StatefulWidget {
  @override
  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  var _futureBuilderFuture;
  List<Widget> _list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 用_futureBuilderFuture保存_getData的结果，以避免不必要的UI重绘
    _futureBuilderFuture = _getData();
  }

  Future _getData() async {
    // 获取排行榜榜单列表
    List<RankDetail> result = await Api.getRankingDetail({});
    var index = 1;
    result.forEach((item) {
      _list.add(FlatButton(onPressed: (){
        Navigator.of(context).pushNamed('/player',arguments: {
          "mid":item.mid
        });
      }, child: MusicListItem(
          data: MusicLabel(
              index: index,
              name: item.name,
              author: item.singerName,
              isPlay: false,
              duration: item.duration),
        )));
      index++;
    });
  }

  Widget _builder(BuildContext context, AsyncSnapshot asyncSnapshot) {
    switch (asyncSnapshot.connectionState) {
      case ConnectionState.none:
        print('还没有开始网络请求');
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        print('active');
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        print('waiting');
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        if (asyncSnapshot.hasError)
          return Text('Error: ${asyncSnapshot.error}');
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: _list,
          ),
        );
      default:
        return Text('还没有开始网络请求');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Welcome(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Text(
            "今日推荐·精选",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        FutureBuilder(future: _futureBuilderFuture, builder: _builder),
      ],
    );
  }
}
