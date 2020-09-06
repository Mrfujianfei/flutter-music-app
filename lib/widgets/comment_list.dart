import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:musicapp/api/api.dart';
import 'package:musicapp/model/comment.dart';
import 'package:musicapp/model/song.dart';
import 'package:musicapp/provider/music_model.dart';
import 'package:musicapp/widgets/comment.dart';
import 'package:provider/provider.dart';

class CommentList extends StatefulWidget {
  String songId;
  int origin;
  CommentList(this.songId, {this.origin = 0});
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> with AutomaticKeepAliveClientMixin<CommentList> {
  int pageNo = 1;
  int pageSize = 20;
  int _total = 0;
  List<Widget> _list = [];
  ScrollController _controller;
  bool _isLoading = false;
  bool _hasMore = false;
  Song _curSong;
  int songId; // 网易云音乐的id

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _curSong = Provider.of<MusicProviderModel>(context, listen: false).curSong;
    _controller = new ScrollController()
      ..addListener(() {
        bool _isBottom =
            _controller.position.pixels == _controller.position.maxScrollExtent;
        if (_isBottom && !_isLoading && _hasMore) {
          _getData();
        }
      });

    _getData();
  }

  _getData() async {
    setState(() {
      _isLoading = true;
    });
    var result = await Api.getCommentList(
      {
        "pageNo": pageNo,
        "pageSize": pageSize,
        "id": widget.songId,
        "origin": widget.origin,
        "name": _curSong.name,
        "singer": _curSong.singer,
        "wySongId": songId
      },
    );
    _hasMore = result['list'].length == pageSize;
    pageNo += 1;
    songId = result['result'];
    _renderList(result['list']);
  }

  _renderList(dataList) {
    _total = _list.length + dataList.length;
    for (var i = 0; i < dataList.length; i++) {
      _list.add(Comment(dataList[i], isLast: _list.length + 1 == _total));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _controller,
      children: <Widget>[
        ..._list,
        Offstage(
          offstage: !_isLoading,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: LoadingBumpingLine.circle(
              size: 40.0,
            ),
          ),
        ),
        Offstage(
          offstage: _isLoading || _hasMore,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            child: Text(
              _list.length==0?"${widget.origin ==0?'🐧':'网易☁'}找不到这首歌~,去看${widget.origin == 0?'网易☁':'🐧'}的评论吧！！！":"😔没有更多啦~",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
