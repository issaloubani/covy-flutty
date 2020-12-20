import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:location/location.dart';

class ServiceNotAvailableException implements Exception {}

class LocationDeniedException implements Exception {}

class LocationDeniedForeverException implements Exception {}

class LocationService {
  final Location locationApi;

  const LocationService(this.locationApi);

  Future<LocationData> getCurrentLocation() async {
    bool _serviceEnabled = await locationApi.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await locationApi.requestService();
      if (!_serviceEnabled) {
        throw ServiceNotAvailableException;
      }
    }

    PermissionStatus _permissionGranted = await locationApi.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationApi.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw LocationDeniedException;
      }
    }

    if (_permissionGranted == PermissionStatus.deniedForever) {
      throw LocationDeniedForeverException;
    }

    return Location().getLocation();
  }

  Future<List<Geocoding.Placemark>> getLocationInfo(
  {String languageCode, double lat, double lon}) {
    return Geocoding.placemarkFromCoordinates(lat, lon,
        localeIdentifier: languageCode);
  }
}
