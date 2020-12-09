import 'package:covid_tracker_app/ui/styles/AppBarItemStyle.dart';
import 'package:flutter/material.dart';

class BubbleIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  BubbleIcon({@required this.onPressed, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Ink(
        decoration: AppBarItemStyle.boxDecoration,
        child: IconButton(
          splashRadius: 15.0,
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
