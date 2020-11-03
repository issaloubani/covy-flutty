import 'package:covid_tracker_app/ui/pages/heart_rate_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../res.dart';

class HeartRateCard extends StatelessWidget {
  const HeartRateCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 8), blurRadius: 10, color: Colors.grey[300])
            ]),
        child: Row(
          children: [
            Lottie.asset(Res.hear_anim, height: 160, frameRate: FrameRate(60)),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "covid_test_subtitle".tr(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 10),
                  Container(
                      width: 170,
                      child: Text(
                          "covid_test_body".tr(),
                          style: TextStyle(
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .fontWeight,
                              color: Colors.black54))),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HeartRatePage(),
                      ));
                    },
                    color: Color(0xFFEF4E7F),
                    child: Text(
                      "Start",
                      style: Theme.of(context).accentTextTheme.button,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
