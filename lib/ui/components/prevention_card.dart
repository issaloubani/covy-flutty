import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../res.dart';

class PreventionCard extends StatelessWidget {
  const PreventionCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 158,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Container(
                  height: 138,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 8),
                            color: Colors.grey[300],
                            blurRadius: 10)
                      ]),
                ),
                Lottie.asset(Res.wear_anim),
                Positioned(
                    top: 28,
                    left: (context.locale.languageCode == 'ar') ? 0 : 128,
                    right: (context.locale.languageCode == 'ar') ? 128 : 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 170,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("mask_prev_title".tr(),
                              style: Theme.of(context).textTheme.headline6),
                          SizedBox(height: 10),
                          Text(
                              "mask_prev_body".tr(),
                              style: TextStyle(
                                  fontWeight: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .fontWeight,
                                  color: Colors.black54)),
                        ],
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
