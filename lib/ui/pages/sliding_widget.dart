import 'package:covid_tracker_app/ui/components/dailysummary/daily_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'more_page.dart';

class DrawerPage {
    static Widget instance(BuildContext context){
      return Container(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: DailySummary.instance()),
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
