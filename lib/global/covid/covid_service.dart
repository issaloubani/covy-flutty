import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class DailySummary {
  final int infected;
  final int recovered;
  final int deaths;

  const DailySummary(this.infected, this.recovered, this.deaths);
}

class DataParseException implements Exception {}

class CovidService {
  final String baseUrl = "https://api.covid19api.com/";
  final Dio dio = Dio();

  // Cache Duration
  Duration summaryCacheDuration = Duration(days: 1);
  final Duration weeklySumCacheDuration = Duration(days: 1);

  //const CovidService(this.dio);
  CovidService() {
    dio.options.baseUrl = this.baseUrl;
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;

    dio.interceptors.add(DioCacheManager(
      CacheConfig(
        baseUrl: this.baseUrl,
      ),
    ).interceptor);
  }

  Future<Response> _fetchSummaryWithSummary() {
    return dio.get("${baseUrl}summary",
        options: buildCacheOptions(summaryCacheDuration));
  }

  Future<Response> _fetchSummary() {
    return dio.get(
      "${baseUrl}summary",
    );
  }

  Future<Response> _fetchWeeklyData(String country) {
    // date format : year-month-dayT00:00:00Z
    // example     : 2020-10-18T11:52:37Z

    // get the current day and the week before
    var now = DateTime.now();
    now = DateTime(now.year, now.month, now.day - 1);
    var weekBeforeNow = DateTime(now.year, now.month, now.day - 8);

    // initialise http request
    String today = "${now.year}-${now.month}-${now.day}T00:00:00Z";
    String weekBefore =
        "${weekBeforeNow.year}-${weekBeforeNow.month}-${weekBeforeNow.day}T00:00:00Z";
    String httpRequest =
        "${baseUrl}country/${country.toLowerCase()}/status/confirmed?from=$weekBefore&to=$today";

    print("Weekly Data Request : $httpRequest");
    // send request
    return dio.get(httpRequest);
  }

  Future<DailySummary> getDSummary(String countryCode) async {
    Response response = await _fetchSummaryWithSummary();

    List json = response.data['Countries'];
    int index = -1;
    try {
      index = json.indexWhere((element) =>
          element["CountryCode"] == "${countryCode.toUpperCase()}");
    } on NoSuchMethodError {
      response = await _fetchSummary();
      json = response.data['Countries'];
      index = json.indexWhere((element) =>
          element["CountryCode"] == "${countryCode.toUpperCase()}");
    }

    Map countryData = json[index];
    return DailySummary(
      countryData['NewConfirmed'],
      countryData['NewRecovered'],
      countryData['NewDeaths'],
    );
  }

  Future<List<double>> getWeeklySummary(String country) async {
    // get weekly summary from now to 7 days ago
    Response json = await _fetchWeeklyData(country);
    print("Weekly Data ${json.data}");

    List jsonResponse = json.data;
    List<int> covidSummary = [];
    List<double> covidCases = List(7);

    jsonResponse.forEach((element) => covidSummary.add(element["Cases"]));
    // calculate summary for each day, 7 days ago
    for (int i = 0; i < covidSummary.length; i++) {
      if (i + 1 < covidSummary.length) {
        covidCases[i] = ((covidSummary[i + 1] - covidSummary[i]).toDouble());
      }
    }

    print("Covid Cases $covidCases");
    return covidCases;
  }
}
