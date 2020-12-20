import 'package:flutter/material.dart';

import '../covid_service.dart';
import 'package:easy_localization/easy_localization.dart';

class Summary extends StatelessWidget {
  final DailySummary dailySummary;

  const Summary({
    @required this.dailySummary,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Color(0xff1F273D),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Indicator("infected".tr(), "${NumberFormat.compact(locale: context.locale.languageCode).format(dailySummary.infected)}", Colors.amber),
              Indicator("recovered".tr(), "${NumberFormat.compact(locale: context.locale.languageCode).format(dailySummary.recovered)}", Colors.green),
              Indicator("deaths".tr(),  "${NumberFormat.compact(locale: context.locale.languageCode).format(dailySummary.deaths)}", Colors.red),
            ]),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const Indicator(this.title, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ]);
  }
}
