import 'package:flutter/material.dart';

const double TAB_WIDTH = 60.0; // tab的宽度
const double INIT_BORDER_X = 30.0; // 初始化border的位置

class MenuDrawer extends StatefulWidget {
  Widget menu;
  List<Widget> tabMenus; // tab目录组件
  List<Widget> children; // 子组件
  MenuDrawer({this.menu, this.tabMenus, this.children});
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  PageController _controller;

  PageController _pageController;

  double _scale = 1.0;

  double _opacity = 0.0;

  double _menuScale = 0.5;

  double _translate = -390.0;

  bool disabled = true;

  double _labelBorder = INIT_BORDER_X; // 底部导航初始位置

  @override
  void initState() {
    _controller = new PageController(initialPage: 1);
    _controller
      ..addListener(() {
        _opacity = 1 - _controller.page;
        _menuScale = 1.0 - _controller.page * 0.5;
        _scale = 0.5 + _controller.page * 0.5;

        setState(() {
          _scale = _scale > 1.0 ? 1.0 : _scale;
          _opacity = _opacity < 0 ? 0.0 : _opacity;
          _menuScale = _menuScale < 0 ? 0.0 : _menuScale;
          _translate = _controller.page * -390.0;
        });
      });

    _pageController = new PageController();
    _pageController.addListener(() {
      setState(() {
        _labelBorder = INIT_BORDER_X + TAB_WIDTH * _pageController.page;
      });
    });
    // 初始化位置
    if (_pageController.positions.isNotEmpty) {
      _labelBorder = _labelBorder = INIT_BORDER_X +
          TAB_WIDTH *
              (_pageController.page - 1 < 0 ? 0 : (_pageController.page - 1));
    }

    // TODO: implement initState
    super.initState();
  }

  List<Widget> _tabMenus() {
    List<Widget> _list = [];
    for (var i = 0; i < widget.tabMenus.length; i++) {
      _list.add(
        GestureDetector(
          onTap: () {
            _pageController.animateToPage(i ,
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
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.amber,
          ),
          Opacity(
            opacity: _opacity,
            child: Transform.scale(
              scale: 1.5 - _scale,
              child: widget.menu,
            ),
          ),
          Transform.scale(
            scale: _scale,
            origin: Offset(250.0, 0.0),
            child: Stack(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      blurRadius: 40.0,
                      spreadRadius: 2.0,
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                    )
                  ]),
                  child: Column(
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
                          transform:
                              Matrix4.translationValues(_labelBorder, 0.0, 0.0),
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
                          controller: _pageController,
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            ...widget.children,
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Transform.translate(
                  offset: Offset(_translate, 0.0),
                  child: PageView(
                    controller: _controller,
                    children: <Widget>[
                      SizedBox(
                        width: double.maxFinite,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
