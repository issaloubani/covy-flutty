import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'indicator.dart';

class DailySummary extends StatefulWidget {
  final infected, recovered, deaths;

  DailySummary(this.infected, this.recovered, this.deaths);

  @override
  _DailySummaryState createState() => _DailySummaryState();
}

class _DailySummaryState extends State<DailySummary> {
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
                title: Text(DateFormat('EEEE').format(DateTime.now()),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.white,
                    )),
                subtitle: Text("Daily Summary",
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
                            title: "Infected",
                            value: "${widget.infected}",
                            color: Colors.amber),
                        Indicator(
                            title: "Recovered",
                            value: "${widget.recovered}",
                            color: Colors.green),
                        Indicator(
                            title: "Deaths",
                            value: "${widget.deaths}",
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
