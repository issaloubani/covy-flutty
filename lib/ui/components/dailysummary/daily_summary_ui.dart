import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../indicator.dart';

class DailySummaryUI extends StatefulWidget {
  final infected, recovered, deaths;

  DailySummaryUI(this.infected, this.recovered, this.deaths);

  @override
  _DailySummaryUIState createState() => _DailySummaryUIState();
}

class _DailySummaryUIState extends State<DailySummaryUI> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color(0xff222B45),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                    DateFormat('EEEE', context.locale.languageCode)
                        .format(DateTime.now()),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.white,
                    )),
                subtitle: Text("daily_summary".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.white,
                    )),
                leading: //Flag('LB', width: 50, height: 30),
                    //Image(image: AssetImage(Res.Chart), width: 40)
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.show_chart,
                            size: 35, color: Colors.amberAccent)),
              ),
              Divider(
                color: Colors.white24,
                height: 30,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Color(0xff1F273D),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Indicator(
                            title: "infected".tr(),
                            value: "${NumberFormat.compact(locale: context.locale.languageCode).format(widget.infected)}",
                            color: Colors.amber),
                        Indicator(
                            title: "recovered".tr(),
                            value: "${NumberFormat.compact(locale: context.locale.languageCode).format(widget.recovered)}",
                            color: Colors.green),
                        Indicator(
                            title: "deaths".tr(),
                            value: "${NumberFormat.compact(locale: context.locale.languageCode).format(widget.deaths)}",
                            color: Colors.red),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
