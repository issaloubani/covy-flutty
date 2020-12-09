import 'package:flutter/material.dart';

abstract class AppBarItemStyle {
  static final BoxDecoration boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15.0),
    boxShadow: [
      BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 0))
    ],
  );

}
