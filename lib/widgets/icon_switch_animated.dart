import 'package:flutter/material.dart';

class IconSwitchAnimated extends StatelessWidget {
  IconData icon;
  double iconSize;
  Color color;
  Function onTap;
  IconSwitchAnimated(
      {this.icon, this.onTap, this.iconSize = 40.0, this.color = Colors.white});
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, anim) {
        return ScaleTransition(child: child, scale: anim);
      },
      duration: Duration(milliseconds: 300),
      child: IconButton(
        key: ValueKey(icon),
        splashColor: Colors.transparent,
        icon: Icon(icon),
        iconSize: iconSize,
        color: color,
        onPressed: onTap,
      ),
    );
  }
}
