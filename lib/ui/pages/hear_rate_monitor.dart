import 'package:covid_tracker_app/ui/components/chart.dart';
import 'package:flutter/material.dart';

class HearRateMonitor extends StatelessWidget {
  const HearRateMonitor({
    Key key,
    @required List<SensorValue> data,
  })  : _data = data,
        super(key: key);

  final List<SensorValue> _data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
          color: Colors.black),
      child: Chart(_data),
    );
  }
}
