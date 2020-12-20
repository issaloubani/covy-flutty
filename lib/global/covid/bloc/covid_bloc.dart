import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid_tracker_app/global/covid/covid_service.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'covid_event.dart';

part 'covid_state.dart';

class CovidBloc extends Bloc<CovidEvent, CovidState> {
  final CovidService service;

  CovidBloc(this.service) : super(CovidInitial());

  @override
  Stream<CovidState> mapEventToState(
    CovidEvent event,
  ) async* {
    if (event is GetDailyData) {
      yield CovidLoadingData();
      DailySummary daily = await service.getDSummary(event.countryCode);
      yield CovidDSLoaded(daily);
    }

    if (event is GetWeeklyData) {
      yield CovidLoadingData();
      List<double> weeklyData = await service.getWeeklySummary(event.country);
      yield CovidWSLoaded(weeklyData);
    }
  }
}
