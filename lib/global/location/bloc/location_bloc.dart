import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:location/location.dart';
import 'package:meta/meta.dart';

import '../location_service.dart';

part 'location_event.dart';

part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService locationService;

  LocationBloc(this.locationService) : super(LocationInitial());

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is InitLocation) {
      yield LocationInitial();
    }
    if (event is GetLocation) {
      try {
        yield LocationLoading();
        LocationData locationData = await locationService.getCurrentLocation();
        List<Geocoding.Placemark> placemarks =
            await locationService.getLocationInfo(
          languageCode: event.languageCode,
          lat: locationData.latitude,
          lon: locationData.longitude,
        );
        yield LocationLoaded(locationData, placemarks);
      } catch (e) {
        yield LocationError(e);
      }
    } else if (event is GetLocationUpdate) {
      try {
        yield UpdatingLocation();
        LocationData locationData = await locationService.getCurrentLocation();
        List<Geocoding.Placemark> placemarks =
            await locationService.getLocationInfo(
          languageCode: event.languageCode,
          lat: locationData.latitude,
          lon: locationData.longitude,
        );
        yield LocationUpdated(locationData, placemarks);
      } catch (e) {
        yield LocationError(e);
      }
    }
  }
}
