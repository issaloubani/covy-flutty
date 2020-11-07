import 'dart:math';

import 'package:covid_tracker_app/ui/components/tip_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../res.dart';

class Tips {
  static showTip({@required BuildContext context}) {
    final tips = [
      TipPage(
        animation: Res.wear_anim,
        title: "tip_mask_title".tr(),
        description: "tip_mask_body".tr(),
        buttonText: "okay".tr(),
      ),
      TipPage(
        animation: Res.sanitizer_anim,
        title: "tip_sanitizer_title".tr(),
        description: "tip_sanitizer_body".tr(),
        buttonText: "okay".tr(),
      ),
      TipPage(
        animation: Res.sneezing_anim,
        title: "tip_sneeze_title".tr(),
        description: "tip_sneeze_body".tr(),
        buttonText: "okay".tr(),
      ),
    ];

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => tips[Random().nextInt(tips.length - 0)],
    ));
  }
}
