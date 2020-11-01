import 'package:flutter/material.dart';

class DragHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(
                40.0,
              )),
          height: 10,
          width: 50),
    );
  }
}
