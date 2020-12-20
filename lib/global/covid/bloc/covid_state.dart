part of 'covid_bloc.dart';

@immutable
abstract class CovidState extends Equatable {
  const CovidState();

  @override
  List<Object> get props => [];
}

class CovidInitial extends CovidState {
  const CovidInitial();
}

class CovidLoadingData extends CovidState {
  const CovidLoadingData();
}

class CovidDataLoaded extends CovidState {
  final DailySummary dailySummary;
  final List<double> weeklySummary;

  const CovidDataLoaded(this.dailySummary, this.weeklySummary);

  @override
  List<Object> get props => [dailySummary, weeklySummary];
}

class CovidDSLoaded extends CovidState {
  final DailySummary dailySummary;

  const CovidDSLoaded(this.dailySummary);

  @override
  List<Object> get props => [dailySummary];
}

class CovidWSLoaded extends CovidState {
  final List<double> weeklySummary;

  const CovidWSLoaded(this.weeklySummary);

  @override
  List<Object> get props => [weeklySummary];
}

class CovidError extends CovidState {
  final Exception exception;

  const CovidError(this.exception);

  @override
  List<Object> get props => [exception];
}
