import 'package:flutter/material.dart';
import 'package:musicapp/model/song.dart';

class SearchLabel extends StatefulWidget {
  Duration dely;
  Song song;
  SearchLabel(this.dely, this.song);
  @override
  _SearchLabelState createState() => _SearchLabelState();
}

class _SearchLabelState extends State<SearchLabel>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  Animation<double> _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = new AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    CurvedAnimation curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart);
    _animation =
        Tween(begin: Offset(0.2, 0.0), end: Offset(0.0, 0)).animate(curve);
    Future.delayed(widget.dely, () {
      _controller.forward();
    });

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: Colors.grey[200],
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50.0,
                width: 50.0,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.0, 5.0),
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          widget.song.picUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 10.0,
                      width: 10.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.song.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "${widget.song.singer}     专辑:《${widget.song.ablbumName}》",
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12.0),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 60.0,
                child: Text(
                  widget.song.duration,
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
