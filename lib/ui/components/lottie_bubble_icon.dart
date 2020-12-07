import 'package:flutter/material.dart';

class LottieBubbleIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  LottieBubbleIcon({@required this.onPressed, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Ink(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: IconButton(
          splashRadius: 15.0,
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
