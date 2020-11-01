import 'package:flutter/material.dart';

class Indicator extends StatefulWidget {
  final String title, value;
  final Color color;

  Indicator({Key key, this.title, this.value, this.color}) : super(key: key);

  @override
  _IndicatorState createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: widget.color,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Text(
            widget.value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
        ]);
  }
}
