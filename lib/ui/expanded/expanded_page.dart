import 'package:carousel_slider/carousel_slider.dart';
import 'package:covid_tracker_app/global/covid/bloc/covid_bloc.dart';
import 'package:covid_tracker_app/global/covid/components/placeholder_box.dart';
import 'package:covid_tracker_app/global/covid/components/summary.dart';
import 'package:covid_tracker_app/global/covid/covid_service.dart';
import 'package:covid_tracker_app/global/theme/theme_service.dart';
import 'package:covid_tracker_app/ui/heartbeat/heart_beat_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../res.dart';

class ExpandedPage extends StatefulWidget {
  ExpandedPage({Key key}) : super(key: key);

  @override
  _ExpandedPageState createState() => _ExpandedPageState();
}

class _ExpandedPageState extends State<ExpandedPage> {
  List<double> covidCases = [0, 0, 0, 0, 0, 0, 0];
  DailySummary summary = DailySummary(0, 0, 0);
  final Map symptoms = {
    "cough".tr(): Res.cough,
    "fever".tr(): Res.fever,
    "Fatigue": Res.fatigue,
    "Problem Breathing": Res.problem_breathing,
  };

  final Map preventions = {
    Res.avoid_crowd: ["Avoid Crowd", "Placeholder Description"],
    Res.facial_mask: ["Facial Mask", "Placeholder Description"],
    Res.stay_home: ["Stay Home", "Placeholder Description"],
    Res.wash_hands: ["Wash Hands", "Placeholder Description"],
  };

  final Map daysOfTheWeek = <int, String>{
    0: "0".tr(),
    1: "1".tr(),
    2: "2".tr(),
    3: "3".tr(),
    4: "4".tr(),
    5: "5".tr(),
    6: "6".tr(),
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.bloc<CovidBloc>().add(GetWeeklyData("lb"));
    context.bloc<CovidBloc>().add(GetDailyData("lb"));
  }

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xff222B45),
      ),
      backgroundColor: const Color(0xff222B45),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: ListView(
            physics: ClampingScrollPhysics(),
            cacheExtent: MediaQuery.of(context).size.height,
            controller: scrollController,
            scrollDirection: Axis.vertical,
            children: [
              buildAppBar(),
              buildWeeklySummaryBloc(),
              BlocConsumer<CovidBloc, CovidState>(
                listener: (BuildContext context, state) {
                  if (state is CovidDSLoaded) {
                    setState(() {
                      // covidCases = state.weeklySummary;
                      summary = state.dailySummary;
                    });
                  }
                },
                buildWhen: (previous, current) {
                  return current is CovidDSLoaded;
                },
                builder: (context, state) {
                  if (state is CovidDSLoaded) {
                    return buildDailySummary();
                  } else if (state is CovidError) {
                    return buildServiceNotAvailable();
                  } else {
                    return PlaceholderBox(height: 100);
                  }
                },
              ),
              buildArrow(),
              buildSymptomsTitle(),
              buildSymptoms(),
              buildPreventionsTitle(),
              CarouselSlider.builder(
                  itemCount: preventions.values.length,
                  itemBuilder: (context, index) => buildPreventionCard(
                      index + 1,
                      preventions.keys.toList()[index],
                      preventions.values.toList()[index][0],
                      preventions.values.toList()[index][1]),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    height: 250,
                    //   aspectRatio: 16/9,
                    //   enlargeCenterPage: true,
                  )),
              buildHeartCard(),
            ],
          ),
        ),
      ),
    );
  }

  BlocConsumer<CovidBloc, CovidState> buildWeeklySummaryBloc() {
    return BlocConsumer<CovidBloc, CovidState>(
      listener: (BuildContext context, state) {
        if (state is CovidWSLoaded) {
          setState(() {
            covidCases = state.weeklySummary;
          });
        }
      },
      buildWhen: (previous, current) {
        return current is CovidWSLoaded;
      },
      builder: (context, state) {
        if (state is CovidWSLoaded) {
          return buildWeeklySummary();
        } else if (state is CovidError) {
          return buildServiceNotAvailable();
        } else {
          return PlaceholderBox(height: 100);
        }
      },
    );
  }

  Center buildServiceNotAvailable() {
    return Center(
        child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(Icons.error_outline, color: Colors.white),
      ),
      title: Text("Service Not Available !"),
    ));
  }

  Container buildPreventionCard(
      int index, String image, String title, String subtitle) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF8bcff7),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  child: Text("$index"),
                ),
              ),
              CircleAvatar(
                maxRadius: 60.0,
                child: Image.asset(image),
              ),
              ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildPreventionsTitle() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(
          "Preventions",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container buildHeartCard() {
    return Container(
      child: const HeartRateCard(),
      color: Colors.white,
    );
  }

  Container buildSymptomsTitle() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: RichText(
          text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
              children: [
                TextSpan(
                    text: "Common",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(text: " Symptoms"),
              ]),
        ),
      ),
    );
  }

  Container buildArrow() {
    return Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
        ),
        child: Center(
          child: Icon(Icons.keyboard_arrow_up_rounded),
        ));
  }

  Padding buildDailySummary() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Summary(dailySummary: summary),
    );
  }

  Padding buildWeeklySummary() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: buildFullBarChart(),
    );
  }

  _markCurrentDay(int key) {
    // print("Key : $key");
    // print("daysOfTheWeek : ${daysOfTheWeek.keys.toList()[key]}");
    // print("Current Day : ${DateFormat("E").format(DateTime.now())}");
    if (key < 7 &&
        daysOfTheWeek.values.toList()[key] ==
            DateFormat("E", context.locale.languageCode)
                .format(DateTime.now())) {
      return BarChartTheme.currentDayBarStyle;
    } else {
      return BarChartTheme.normalDayBarStyle;
    }
  }

  Widget buildBarChartTitle() {
    return ListTile(
        title: Text(
            DateFormat('MMMMd', context.locale.languageCode)
                .format(DateTime.now()),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.white,
            )),
        subtitle: Text("weekly_summary".tr(),
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
        ));
  }

  Widget buildButtonChartDivider() {
    return Divider(
      color: Colors.white24,
      height: 30,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }

  FlGridData buildChartGrid() {
    return FlGridData(
        show: true,
        checkToShowHorizontalLine: (value) => value % 3 == 0,
        getDrawingHorizontalLine: (value) => BarChartTheme.gridLinesStyle);
  }

  List<BarChartGroupData> buildDataButtons() {
    return covidCases
        .asMap()
        .map((key, value) => MapEntry(
            key,
            BarChartGroupData(x: key, barRods: [
              BarChartRodData(y: value, colors: _markCurrentDay(key))
            ])))
        .values
        .toList();
  }

  FlTitlesData buildTitlesData() {
    return FlTitlesData(
        leftTitles: SideTitles(
          margin: 20.0,
          showTitles: true,
          getTextStyles: (value) {
            return BarChartTheme.chartTextStyle;
          },
          getTitles: (value) {
            if (value == 0) {
              return "0";
            }
            if (value % 3 == 0) {
              if (value > 1000) {
                //  return "${(value / 1000).toStringAsFixed(1)} K";
                return "${NumberFormat.compact().format(value)}";
              }
              return "${value.toInt()}";
            }
            return "";
          },
        ),
        show: true,
        bottomTitles: SideTitles(
            getTextStyles: (value) {
              return BarChartTheme.chartTextStyle;
            },
            margin: 20.0,
            showTitles: true,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return "0".tr();
                case 1:
                  return "1".tr();
                case 2:
                  return "2".tr();
                case 3:
                  return "3".tr();
                case 4:
                  return "4".tr();
                case 5:
                  return "5".tr();
                case 6:
                  return "6".tr();
                default:
                  return "";
              }
            }));
  }

  BarChart _buildBarChart() {
    return BarChart(BarChartData(
      maxY: covidCases.reduce((value, element) => value > element
          ? (value + (value * 0.05))
          : (element + (element * 0.05))),
      alignment: BarChartAlignment.spaceBetween,
      barTouchData: BarTouchData(enabled: false),
      borderData: FlBorderData(show: false),
      gridData: buildChartGrid(),
      titlesData: buildTitlesData(),
      barGroups: buildDataButtons(),
    ));
  }

  Widget buildListView() {
    const radius = Radius.circular(30.0);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: radius, topRight: radius)),
      child: ListView(
        children: [Text("Hello")],
      ),
    );
  }

  Widget buildFullBarChart() {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(15.0),
        color: const Color(0xff222B45),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildBarChartTitle(),
          //   buildButtonChartDivider(),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget buildSymptom(String text, String image) {
    return Container(
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        fit: StackFit.expand,
        alignment: Alignment.center,
        //alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(26.0),
            child: Container(
              height: 170,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFD3D3D3).withOpacity(.50),
                        blurRadius: 20,
                        offset: const Offset(3, 7))
                  ]),
            ),
          ),
          Positioned(
            left: 30,
            top: 0,
            child: Image.asset(
              image,
              height: 100,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            // top: 0,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                text,
                softWrap: true,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline5.fontSize,
                    color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSymptoms() {
    return Container(
      color: Colors.white,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return buildSymptom(
            symptoms.keys.toList()[index],
            symptoms.values.toList()[index],
          );
        },
        physics: ClampingScrollPhysics(),
        itemCount: symptoms.length,
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: const Color(0xff222B45),
      elevation: 0,
    );
  }
}

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
          color: Colors.white,
          boxShadow: [SlidingPanelTheme.shadow],
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          children: [
            Container(
              height: 160,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(Res.hear_anim),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "covid_test_subtitle".tr(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        "covid_test_body".tr(),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              elevation: 0,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => HeartBeatPage())),
              color: Color(0xFFEF4E7F),
              child: Text(
                "start".tr(),
                style: Theme.of(context).accentTextTheme.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
