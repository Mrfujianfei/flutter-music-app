import 'package:flutter/material.dart';
import 'package:musicapp/api/api.dart';
import 'package:musicapp/model/music.dart';
import 'package:musicapp/model/recommend_list.dart';
import 'package:musicapp/widgets/music_list_item.dart';
import 'package:musicapp/widgets/welcome.dart';

class Recommend extends StatefulWidget {
  @override
  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
var _futureBuilderFuture = null;
  List<Widget> _list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    // 用_futureBuilderFuture保存_getData的结果，以避免不必要的UI重绘
    _futureBuilderFuture =_getData();
    
    for (var i = 0; i < 20; i++) {
      _list.add(MusicListItem(
        data: MusicLabel(
          index: i + 1,
          name: "歌名${i}",
          author: "作者${i}",
          isPlay: i == 5 ? true : false,
        ),
      ));
    }
    // this.getData();
  }

  Future _getData() async {
    RecommendList result = await Api.getRecommendList({
      "id":71,
      "pageNo":1,
      "pageSize":20
    });
    print('-----');
    print(result);
  }

  Widget _builder(BuildContext context, AsyncSnapshot asyncSnapshot){
    print('我执行了');
    Widget _widget = null;
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
       print('done');
       if (asyncSnapshot.hasError) return Text('Error: ${asyncSnapshot.error}');
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
        FlatButton(onPressed: (){
          print("11");
          Navigator.of(context).pushNamed('/player');
        }, child: Text(
          "听歌"
        )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Text(
            "今日推荐·精选",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        FutureBuilder(
          future: _futureBuilderFuture,
          builder: _builder),
        
      ],
    );
  }
}
