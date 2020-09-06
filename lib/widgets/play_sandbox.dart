import 'package:flutter/material.dart';
import 'package:musicapp/widgets/record.dart';
import 'package:musicapp/widgets/transition.dart';
import 'package:provider/provider.dart';
import 'package:musicapp/provider/music_model.dart';

class PlaySandbox extends StatefulWidget {
  @override
  _PlaySandboxState createState() => _PlaySandboxState();
}

class _PlaySandboxState extends State<PlaySandbox>
    with TickerProviderStateMixin {
  double _top = 0.0;
  double _moveStart = 0.0;
  AnimationController _recordController;
  IconData _actionIcon = Icons.play_arrow;
  bool _isTouching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _recordController =
        new AnimationController(duration: Duration(seconds: 30), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0.0,
      top: _top,
      child: GestureDetector(
        onVerticalDragUpdate: (dragDownDetails) {
          double _nweTop = dragDownDetails.globalPosition.dy - 50.0;
          setState(() {
            _top = _nweTop < 0 ? 0.0 : _nweTop > 610.0 ? 610.0 : _nweTop;
          });
        },
        child: SafeArea(
          child: Container(
            width: 120.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.blue,
            ),
            child: Consumer<MusicProviderModel>(
              builder: (context, model, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 5.0),
                    SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: Stack(
                        children: <Widget>[
                          AnimatedRecord(
                            controller: _recordController,
                            url: model.curSong != null ? model.curSong.id : '',
                          ),
                          AnimatedSwitcher(
                            transitionBuilder: (child, anim) {
                              return ScaleTransition(child: child, scale: anim);
                            },
                            duration: Duration(milliseconds: 300),
                            child: IconButton(
                              key: ValueKey(_actionIcon),
                              icon: Icon(_actionIcon),
                              color: Colors.white,
                              onPressed: () {
                                if (model.curSong == null) {
                                  return;
                                }
                                setState(() {
                                   model.togglePlay();
                                  if (_actionIcon == Icons.play_arrow) {
                                    _actionIcon = Icons.pause;
                                  } else {
                                    _actionIcon = Icons.play_arrow;
                                  }
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          model.curSong != null ? model.curSong.name : '歌名',
                          style: TextStyle(fontSize: 14.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          model.curSong != null ? model.curSong.singer : '歌手',
                          style: TextStyle(fontSize: 10.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
