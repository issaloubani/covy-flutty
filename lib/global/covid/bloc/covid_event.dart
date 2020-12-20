part of 'covid_bloc.dart';

@immutable
abstract class CovidEvent extends Equatable {
  const CovidEvent();

  @override
  List<Object> get props => [];
}

class GetDailyData extends CovidEvent {
  final String countryCode;

  const GetDailyData(this.countryCode);

  @override
  List<Object> get props => [countryCode];
}

class GetWeeklyData extends CovidEvent {
  final String country;

  const GetWeeklyData(this.country);

  @override
  List<Object> get props => [country];
}

class GetDWData extends CovidEvent {
  final String country;
  final String countryCode;

  const GetDWData(this.country, this.countryCode);

  @override
  List<Object> get props => [country, countryCode];
}
