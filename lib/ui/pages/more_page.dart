import 'package:covid_tracker_app/modules/Tips.dart';
import 'package:covid_tracker_app/res.dart';
import 'package:covid_tracker_app/ui/components/dailysummary/daily_summary.dart';
import 'package:covid_tracker_app/ui/components/heart_rate_card.dart';
import 'package:covid_tracker_app/ui/components/prevention_card.dart';
import 'package:covid_tracker_app/ui/components/symptoms_list.dart';
import 'package:covid_tracker_app/ui/components/title_text.dart';
import 'package:covid_tracker_app/ui/components/weeklysummary/weekly_summary.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MorePage extends StatefulWidget {
  MorePage({Key key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
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
              DailySummary.instance(),
              WeeklySummary.instance(),
              TitleText(title: "covid_test_title".tr()),
              HeartRateCard(),
            ]))
          ],
        ),
      ),
    );
  }
}
