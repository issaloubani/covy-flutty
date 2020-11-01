import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final Map daysOfTheWeek = <int, String>{
  0: "Mon",
  1: "Tue",
  2: "Wed",
  3: "Thur",
  4: "Fri",
  5: "Sat",
  6: "Sun"
};

final chartTextStyle = TextStyle(
  color: Colors.white70,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
final FlLine gridLinesStyle = FlLine(
  color: Colors.white12,
  strokeWidth: 1.0,
  dashArray: [5],
);
final currentDayBarStyle = [Colors.white12, Colors.blue];
final normalDayBarStyle = [Colors.white12, Colors.red];

class WeeklySummary extends StatefulWidget {
  final List<double> covidCases;

  WeeklySummary(this.covidCases);

  @override
  _WeeklySummaryState createState() => _WeeklySummaryState();
}

class _WeeklySummaryState extends State<WeeklySummary> {
  _markCurrentDay(int key) {
    // print("Key : $key");
    // print("daysOfTheWeek : ${daysOfTheWeek.keys.toList()[key]}");
    // print("Current Day : ${DateFormat("E").format(DateTime.now())}");
    if (daysOfTheWeek.values.toList()[key] ==
        DateFormat("E").format(DateTime.now())) {
      return currentDayBarStyle;
    } else {
      return normalDayBarStyle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color(0xff222B45),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                  title: Text(DateFormat('MMMMd').format(DateTime.now()),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.white,
                      )),
                  subtitle: Text("Weekly Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white,
                      )),
                  leading: //Flag('LB', width: 50, height: 30),
                      //Image(image: AssetImage(Res.Chart), width: 40)
                      CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.bar_chart, size: 35, color: Colors.blue),
                  )),
              Divider(
                color: Colors.white24,
                height: 30,
                thickness: 1,
                indent: 5,
                endIndent: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: BarChart(BarChartData(
                  maxY: widget.covidCases.reduce((value, element) =>
                      value > element
                          ? (value + (value * 0.05))
                          : (element + (element * 0.05))),
                  alignment: BarChartAlignment.spaceBetween,
                  barTouchData: BarTouchData(enabled: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                      show: true,
                      checkToShowHorizontalLine: (value) => value % 3 == 0,
                      getDrawingHorizontalLine: (value) => gridLinesStyle),
                  titlesData: FlTitlesData(
                      leftTitles: SideTitles(
                        margin: 20.0,
                        showTitles: true,
                        getTextStyles: (value) {
                          return chartTextStyle;
                        },
                        getTitles: (value) {
                          if (value == 0) {
                            return "0";
                          }
                          if (value % 3 == 0) {
                            if (value > 1000) {
                              return "${(value / 1000).toStringAsFixed(1)} K";
                            }
                            return "${value.toInt()}";
                          }
                          return "";
                        },
                      ),
                      show: true,
                      bottomTitles: SideTitles(
                          getTextStyles: (value) {
                            return chartTextStyle;
                          },
                          margin: 20.0,
                          showTitles: true,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return "Mon";
                              case 1:
                                return "Tue";
                              case 2:
                                return "Wed";
                              case 3:
                                return "Thu";
                              case 4:
                                return "Fri";
                              case 5:
                                return "Sat";
                              case 6:
                                return "Sun";
                              default:
                                return "";
                            }
                          })),
                  barGroups: widget.covidCases
                      .asMap()
                      .map((key, value) => MapEntry(
                          key,
                          BarChartGroupData(x: key, barRods: [
                            BarChartRodData(
                                y: value, colors: _markCurrentDay(key))
                          ])))
                      .values
                      .toList(),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
