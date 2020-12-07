import 'package:covid_tracker_app/common/statistics.dart' as Statistics;
import 'package:covid_tracker_app/modules/Tips.dart';
import 'package:covid_tracker_app/res.dart';
import 'package:covid_tracker_app/ui/components/daily_summary.dart';
import 'package:covid_tracker_app/ui/components/heart_rate_card.dart';
import 'package:covid_tracker_app/ui/components/prevention_card.dart';
import 'package:covid_tracker_app/ui/components/symptoms_list.dart';
import 'package:covid_tracker_app/ui/components/title_text.dart';
import 'package:covid_tracker_app/ui/components/weekly_summary.dart';
import 'package:easy_localization/easy_localization.dart';
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
        if (snapshot.data.length >= 7) {
          List<double> data = snapshot.data;
          data = data.sublist(data.length - 7, data.length - 1);
          return WeeklySummary(data);
        }
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
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   actions: [],
      // ),
      /*    body: Container(
        color: Colors.white,
        child: NotificationListener(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return;
          },
          child: ListView(
            addAutomaticKeepAlives: true,

            children: [
              SliverPersistentHeader(
                  pinned: false, floating: true, delegate: CovidIllustration(minExtent: 150.0,maxExtent: 250.0)),
              TitleText(title: "symptoms".tr()),
              SymptomsList(),
              TitleText(title: "preventions".tr()),
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
                    onPressed: () {
                      Tips.showTip(context: context);
                    },
                  ),
                ),
              ),
              TitleText(title: "statistics".tr()),
              dailySummary,
              weeklySummary,
              TitleText(title: "covid_test_title".tr()),
              HeartRateCard(),
            ],
          ),
        ),
      ),*/
      body: Material(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              pinned: false,
              expandedHeight: 250.0,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  context.locale.languageCode == "ar"
                      ? Res.pale_virus_test_ar
                      : Res.pale_virus_test_en,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              TitleText(title: "symptoms".tr()),
              SymptomsList(),
              TitleText(title: "preventions".tr()),
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
                    onPressed: () {
                      Tips.showTip(context: context);
                    },
                  ),
                ),
              ),
              TitleText(title: "statistics".tr()),
              dailySummary,
              weeklySummary,
              TitleText(title: "covid_test_title".tr()),
              HeartRateCard(),
            ]))
          ],
        ),
      ),
    );
  }
}
