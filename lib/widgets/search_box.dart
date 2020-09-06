import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  Function onSubmit;
  Function onChange;
  String value;
  SearchBox({this.onSubmit, this.onChange, this.value});

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  bool _isShowHint = true;

  double _width = 70.0;

  TextEditingController _value = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        _width = 420.0;
      });
    });

    _value.text = widget.value;
  }

  @override
  void didUpdateWidget(SearchBox oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        _value.text = widget.value;
        _isShowHint = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: AnimatedContainer(
          width: _width,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(80.0)),
          duration: Duration(milliseconds: 500),
          curve: Curves.bounceOut,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
          height: 40.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.search,
                color: Color.fromRGBO(57, 57, 57, 1),
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    Positioned(
                      top: -1,
                      child: Opacity(
                        opacity: _isShowHint ? 1 : 0,
                        child: Text(
                          "请输入歌名、歌手 ~",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      ),
                    ),
                    Container(
                      height: 25.0,
                      child: TextField(
                        controller: _value,
                        cursorWidth: 1.0,
                        maxLength: 20,
                        style: TextStyle(
                          color: Colors.grey[700],
                          textBaseline: TextBaseline.alphabetic,
                        ),
                        onSubmitted: widget.onSubmit,
                        onChanged: (value) {
                          widget.onChange(value);
                          if (!_isShowHint && value != '') {
                            return;
                          }
                          setState(() {
                            _isShowHint = value != '' ? false : true;
                          });
                        },
                        cursorColor: Color.fromRGBO(57, 57, 57, 1),
                        decoration: InputDecoration(
                          fillColor: Colors.red,
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
