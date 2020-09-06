import 'package:flutter/material.dart';
import 'package:musicapp/pages/lyerics.dart';
import 'package:musicapp/pages/player.dart';
import 'package:musicapp/provider/music_model.dart';
import 'package:musicapp/widgets/nav_bar.dart';
import 'package:musicapp/widgets/tab_view.dart';
import 'package:provider/provider.dart';

class PlayingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            children: <Widget>[
              Player(),
              Lyerics(),
            ],
          ),
          Consumer<MusicProviderModel>(
            builder: (context, model, child) {
              return NavBar(title: "${model.curSong.name}--${model.curSong.singer}");
            },
          ),
        ],
      ),
    );
  }
}
