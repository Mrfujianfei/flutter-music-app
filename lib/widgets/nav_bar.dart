import 'package:flutter/material.dart';
import 'package:musicapp/provider/music_model.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  String title;
  NavBar({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // height: 60.0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SizedBox(
                  width: 30.0,
                  child: Icon(Icons.chevron_left),
                ),
              ),
              SizedBox(
                width: 120.0,
                child: Consumer<MusicProviderModel>(
                    builder: (context, model, child) {
                  return Text(
                    title == null ? model.curSong.name : title,
                    style: TextStyle(fontSize: 16.0),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  );
                }),
              ),
              SizedBox(
                width: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
