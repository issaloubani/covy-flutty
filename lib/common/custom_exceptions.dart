class LocationDeniedException implements Exception {
  String message =
      "Location has been denied, be sure to give proper permissions.";

  String toString() => "LocationDeniedException: $message";
}

class LocationDeniedForeverException implements Exception {
  String message =
      "Location has been denied forever !! Be sure to give proper permissions.";

  String toString() => "LocationDeniedForeverException: $message";
}
