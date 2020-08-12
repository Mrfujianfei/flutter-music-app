import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:musicapp/api/api.dart';
import 'package:musicapp/model/song.dart';
import 'package:musicapp/widgets/search_box.dart';
import 'package:musicapp/widgets/search_label.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> _chips = [];

  // 初始化搜索加载
  bool _isLoading = false;

  // 加载更多
  bool _isLoadingMore = false;

  // 是否还有更多
  bool _hasMore = true;

  // 列表数据
  List<Widget> _list = [];

  ScrollController _controller;

  int pageNo = 1;

  int pageSize = 20;

  String _searchValue = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getChipsFromPreference();

    // _renderList(['data1', 'data2', 'data3','data1', 'data2', 'data3', 'data2', 'data3', 'data2', 'data3']);

    _controller = new ScrollController();
    _controller.addListener(() {
      bool _isBottom =
          _controller.position.pixels == _controller.position.maxScrollExtent;
      if (_isBottom && !_isLoadingMore) {
        setState(() {
          _isLoadingMore = true;
        });
        pageNo += 1;
        _doSearch();
      }
    });
  }

  _getChipsFromPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _list = prefs.getStringList("searchList");
    _chips = _list == null ? [] : _list;
    setState(() {});
  }

  _onSubmit(value) async {
    _searchValue = value;
    if (value == '') {
      setState(() {
        _list = [];
      });
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> searchList = prefs.getStringList("searchList");
    // 将最新输入的放前面
    searchList = searchList == null ? [value] : [value, ...searchList];
    if (searchList.length > 10) {
      searchList = searchList.sublist(0, 10);
    }
    prefs.setStringList("searchList", searchList);
    _chips = searchList;
    setState(() {
      _isLoading = true;
    });
    _doSearch();
  }

  _doSearch() async {
    // 没有更多数据了
    if (_list.length > 50 || !_hasMore) {
      setState(() {
        _hasMore = false;
        _isLoadingMore = false;
      });
      return;
    }

    List<Song> result = await Api.doSearch(
        {"key": _searchValue, "pageNo": pageNo, 'pageSize': pageSize});
    _isLoadingMore = false;
    _isLoading = false;
    _hasMore = result.length < pageSize ? false : true;
    _renderList(result);
  }

  _renderList(dataList) {
    for (var i = 0; i < dataList.length; i++) {
      _list.add(SearchLabel(Duration(milliseconds: 100), dataList[i]));
    }
    setState(() {});
  }

  _renderChips() {
    return _chips.map(((item) {
      return InputChip(
        label: Text(item),
        deleteIcon: Icon(Icons.close, size: 15.0),
        onDeleted: () {},
        onSelected: (isSelected) {
          print(isSelected);
        },
        backgroundColor: Colors.grey[200],
      );
    })).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SearchBox(
            onSubmit: _onSubmit,
            onChange: (value) {
              if (value == '') {
                setState(() {
                  _list = [];
                });
                return;
              }
            },
          ),
          Offstage(
            offstage: _list.length != 0 || _isLoading,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Container(
                width: double.maxFinite,
                // color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "最近搜索",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.grey[400],
                            size: 22.0,
                          ),
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setStringList("searchList", []);
                            setState(() {
                              _chips = [];
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Wrap(
                      spacing: 10.0,
                      children: <Widget>[
                        ..._renderChips(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Offstage(
            offstage: _list.length == 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5.0,
                    spreadRadius: 0,
                    color: Colors.grey[100],
                    offset: Offset(0.0, 5.0),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    "单曲",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
          Offstage(
            offstage: !_isLoading,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 100.0),
              child: Center(
                child: LoadingJumpingLine.circle(),
              ),
            ),
          ),
          Expanded(
            child: Offstage(
              offstage: _isLoading,
              child: ListView(
                controller: _controller,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                children: <Widget>[
                  ..._list,
                  Offstage(
                    offstage: !_isLoadingMore || !_hasMore,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: LoadingBumpingLine.circle(
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: _hasMore || _list.length == 0,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0),
                        child: Text(
                          "没有更多啦~",
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[300]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
