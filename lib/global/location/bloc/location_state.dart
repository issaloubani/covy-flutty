part of 'location_bloc.dart';

@immutable
abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];

  bool needBuild() {
    // Method required by the buildWhen call back to indicate if the state
    // Requires a UI build or not
    return true;
  }
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

abstract class UpdateLocationEvent extends LocationState {
  final LocationData locationData;
  final List<Geocoding.Placemark> placemarks;

  const UpdateLocationEvent(this.locationData, this.placemarks);

  @override
  List<Object> get props => [locationData, placemarks];
}

class LocationLoaded extends UpdateLocationEvent {
  const LocationLoaded(
      LocationData locationData, List<Geocoding.Placemark> placemarks)
      : super(locationData, placemarks);
}

class LocationUpdated extends UpdateLocationEvent {
  const LocationUpdated(
      LocationData locationData, List<Geocoding.Placemark> placemarks)
      : super(locationData, placemarks);

  @override
  bool needBuild() {
    return false;
  }
}

class LocationError extends LocationState {
  final Exception exception;

  const LocationError(this.exception);

  @override
  List<Object> get props => [exception];
}

class UpdatingLocation extends LocationState {
  const UpdatingLocation();

  @override
  bool needBuild() {
    return false;
  }
}
