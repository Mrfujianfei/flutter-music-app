import 'package:flutter/material.dart';

const double TAB_WIDTH = 100.0; // tab的宽度
const double INIT_BORDER_X = 40.0; // 初始化border的位置

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

  double _labelBorder = 40.0; // 底部导航初始位置

  @override
  void initState() {
    // TODO: implement initState

    // 在初始化的时候对_controller进行监听
    _controller..addListener(() {
       setState(() {
          _labelBorder =INIT_BORDER_X + TAB_WIDTH * _controller.page;
       });
      });
    super.initState();
  }

  List<Widget> _tabMenus() {
   return widget.tabMenus.map((item) => SizedBox(
              width: TAB_WIDTH,
              child: Center(
                child: item,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: _tabMenus(),
        ),
        Transform(
          transform: Matrix4.translationValues(_labelBorder, 0.0, 0.0),
          child: Container(
            height: 10.0,
            width: 20.0,
            color: Colors.green,
          ),
        ),
        Expanded(
            child: PageView(
          controller: _controller,
          children: <Widget>[...widget.children],
        ))
      ],
    );
  }
}