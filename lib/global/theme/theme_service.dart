import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Button Chart Theme
abstract class BarChartTheme {
  static const chartTextStyle = TextStyle(
    color: Colors.white70,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static final FlLine gridLinesStyle = FlLine(
    color: Colors.white12,
    strokeWidth: 1.0,
    dashArray: [5],
  );
  static const currentDayBarStyle = [Colors.white12, Colors.blue];
  static const normalDayBarStyle = [Colors.white12, Colors.red];
}

abstract class IconButtonTheme {
  static final shadow = BoxShadow(
      color: const Color(0xFFD3D3D3).withOpacity(.50),
      blurRadius: 2,
      offset: const Offset(0, 0));
}

abstract class SlidingPanelTheme {
  static final shadow = BoxShadow(
      color: const Color(0xFFD3D3D3).withOpacity(.83),
      blurRadius: 30,
      offset: const Offset(3, 7));
}
