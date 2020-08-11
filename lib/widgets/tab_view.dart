import 'package:flutter/material.dart';

const double TAB_WIDTH = 60.0; // tab的宽度
const double INIT_BORDER_X = 30.0; // 初始化border的位置

class TabView extends StatefulWidget {
  int initTab; // 初始化tab项
  List<Widget> tabMenus; // tab目录组件
  List<Widget> children; // 子组件
  TabView({this.children, this.tabMenus, this.initTab = 0});
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  // PageView控制器
  PageController _controller = new PageController();

  double _labelBorder = INIT_BORDER_X; // 底部导航初始位置

  @override
  void initState() {
    // TODO: implement initState

    // 在初始化的时候对_controller进行监听
    _controller
      ..addListener(() {
        setState(() {
          _labelBorder = INIT_BORDER_X + TAB_WIDTH * _controller.page;
        });
      });
    super.initState();
  }

  List<Widget> _tabMenus() {
    List<Widget> _list = [];
    for (var i = 0; i < widget.tabMenus.length; i++) {
      _list.add(
        GestureDetector(
          onTap: () {
            _controller.animateToPage(i,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          child: SizedBox(
            width: TAB_WIDTH,
            child: Center(
              child: widget.tabMenus[i],
            ),
          ),
        ),
      );
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Offstage(
          offstage: widget.tabMenus.length == 0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5),
            child: SafeArea(
              child: Row(
                children: _tabMenus(),
              ),
            ),
          ),
        ),
        Offstage(
          offstage: widget.tabMenus.length == 0,
          child: Transform(
            transform: Matrix4.translationValues(_labelBorder, 0.0, 0.0),
            child: Container(
              height: 5.0,
              width: 20.0,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: PageView(
            controller: _controller,
            children: <Widget>[...widget.children],
          ),
        )
      ],
    );
  }
}
