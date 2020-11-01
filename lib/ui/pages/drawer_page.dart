import 'package:covid_tracker_app/common/statistics.dart' as Statistics;
import 'package:covid_tracker_app/ui/components/daily_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

import 'more_page.dart';

class DrawerPage extends StatefulWidget {
  final ScrollController mainController;
  final BuildContext context;

  DrawerPage(this.context, {Key key, this.mainController}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: dailySummary),
            Material(
              borderRadius: BorderRadius.circular(
                30.0,
              ),
              child: IconButton(
                splashRadius: 30.0,
                icon: Icon(Icons.keyboard_arrow_down),
                tooltip: "more",
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MorePage(),
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
