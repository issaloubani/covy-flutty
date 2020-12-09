import 'package:flutter/material.dart';
import 'package:covid_tracker_app/common/statistics.dart' as Statistics;
import 'package:shimmer/shimmer.dart';

import 'daily_summary_ui.dart';

class DailySummary {
  static Widget instance() {
    return FutureBuilder(
      future: Statistics.getLebanonSummary(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var lebanonData = snapshot.data;
          // infected = lebanonData['NewConfirmed'];
          // recovered = lebanonData['NewRecovered'];
          // deaths = lebanonData['NewDeaths'];
          return DailySummaryUI(lebanonData['NewConfirmed'],
              lebanonData['NewRecovered'], lebanonData['NewDeaths']);
        } else if (snapshot.hasError) {
          return Text("An Error Occurred");
        } else {
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 350.0,
                  height: 250.0,
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