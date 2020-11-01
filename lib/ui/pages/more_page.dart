import 'package:covid_tracker_app/common/statistics.dart' as Statistics;
import 'package:covid_tracker_app/ui/components/daily_summary.dart';
import 'package:covid_tracker_app/ui/components/heart_rate_card.dart';
import 'package:covid_tracker_app/ui/components/prevention_card.dart';
import 'package:covid_tracker_app/ui/components/symptoms_list.dart';
import 'package:covid_tracker_app/ui/components/title_text.dart';
import 'package:covid_tracker_app/ui/components/weekly_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MorePage extends StatefulWidget {
  MorePage({Key key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  FutureBuilder weeklySummary = FutureBuilder(
    future: Statistics.getWeeklySummary(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return WeeklySummary(snapshot.data);
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
  FutureBuilder dailySummary = FutureBuilder(
    future: Statistics.getLebanonSummary(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        var lebanonData = snapshot.data;
        // infected = lebanonData['NewConfirmed'];
        // recovered = lebanonData['NewRecovered'];
        // deaths = lebanonData['NewDeaths'];
        return DailySummary(lebanonData['NewConfirmed'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [],
      ),
      body: Container(
        color: Colors.white,
        child: NotificationListener(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return;
          },
          child: ListView(
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            children: [
              TitleText(title: "Symptoms"),
              SymptomsList(),
              TitleText(title: "Preventions"),
              PreventionCard(),
              Align(
                child: Material(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                  child: IconButton(
                    splashRadius: 30.0,
                    icon: Icon(Icons.keyboard_arrow_down),
                    tooltip: "more",
                    onPressed: () {},
                  ),
                ),
              ),
              TitleText(title: "Statistics"),
              dailySummary,
              weeklySummary,
              TitleText(title: "Covid-19 Test"),
              HeartRateCard(),
            ],
          ),
        ),
      ),
    );
  }
}
