import 'package:covid_tracker_app/common/statistics.dart' as Statistics;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'weekly_summary_ui.dart';

class WeeklySummary {
  static Widget instance() {
    return FutureBuilder(
      future: Statistics.getWeeklySummary(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length >= 7) {
            List<double> data = snapshot.data;
            data = data.sublist(data.length - 7, data.length - 1);
            return WeeklySummaryUI(data);
          }
          return WeeklySummaryUI(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("An Error Occurred");
        } else {
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 350.0,
                  height: 450.0,
                  child: Shimmer.fromColors(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[400],
                      ),
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[350],
                    direction: ShimmerDirection.ltr,
                  )),
            ),
          );
        }
      },
    );
  }
}
