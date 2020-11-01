import 'dart:convert';

import 'package:http/http.dart' as http;

final String baseUrl = "https://api.covid19api.com/";

Future<http.Response> _fetchSummary() {
  return http.get(baseUrl + "summary");
}

Future<Map> getLebanonSummary() async {
  var response = await _fetchSummary();
  List json = jsonDecode(response.body)['Countries'];
  int index = json.indexWhere((element) => element["Country"] == "Lebanon");
  Map lebanonData = json[index];
  return lebanonData;
}

Future<http.Response> _fetchWeeklyData() {
  /*
  date format : year-month-dayT00:00:00Z
  example     : 2020-10-18T11:52:37Z
  * */
  // get the current day and the week before
  var now = DateTime.now();
  now = DateTime(now.year, now.month, now.day - 1);
  var weekBeforeNow = DateTime(now.year, now.month, now.day - 7);

  // init http request
  String today = "${now.year}-${now.month}-${now.day}T00:00:00Z";
  String weekBefore =
      "${weekBeforeNow.year}-${weekBeforeNow.month}-${weekBeforeNow.day}T00:00:00Z";
  String httpRequest =
      "${baseUrl}country/lebanon/status/confirmed?from=$weekBefore&to=$today";
  print("Http request: " + httpRequest);
  // send request
  return http.get(httpRequest);
}

Future<List<double>> getWeeklySummary() async {
/*  List json = jsonDecode(response.body)['Countries'];
  int index = json.indexWhere(
          (element) => element["Country"] == "Lebanon");
  Map lebanonData = json[index];
  print(lebanonData);*/
  var json = await _fetchWeeklyData();
  List jsonResponse = jsonDecode(json.body);
  List<int> covidSummary = [];
  List<double> covidCases = [];

  jsonResponse.forEach((element) => covidSummary.add(element["Cases"]));
  for (int i = 0; i < covidSummary.length; i++) {
    if (i + 1 < covidSummary.length) {
      covidCases.add((covidSummary[i + 1] - covidSummary[i]).toDouble());
    }
  }
  return covidCases;
}
