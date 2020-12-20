part of 'location_bloc.dart';

@immutable
abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class InitLocation extends LocationEvent {
  const InitLocation();
}

class GetLocation extends LocationEvent {
  final String languageCode;

  const GetLocation(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class GetLocationUpdate extends LocationEvent {
  final String languageCode;

  const GetLocationUpdate(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}
