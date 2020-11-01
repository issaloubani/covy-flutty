import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GooMaps extends StatefulWidget {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = HashSet<Marker>();
  final Set<Circle> _circles = HashSet<Circle>();
  final double radius = 30;
  final Color circleColor = Colors.blue;
  final int strokeWidth = 3;

  GooMaps({Key key}) : super(key: key);

  void addMarker(LatLng position) {
    final String markerId = "marker_id${_markers.length}";
    _markers.add(Marker(position: position, markerId: MarkerId(markerId)));
  }

  void addCircle(LatLng position) {
    final String circleId = "circle_id${_markers.length}";
    _circles.add(Circle(
        center: position,
        circleId: CircleId(circleId),
        radius: radius,
        strokeWidth: strokeWidth,
        strokeColor: circleColor.withOpacity(0.7),
        fillColor: circleColor.withOpacity(0.5)));
  }

  Future<GoogleMapController> getController() {
    return _controller.future;
  }

  @override
  _GooMapsState createState() => _GooMapsState();
}

class _GooMapsState extends State<GooMaps> {
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.8154533, 35.5050067),
    zoom: 14.738,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      liteModeEnabled: false,
      zoomControlsEnabled: false,
      mapType: MapType.terrain,
      markers: widget._markers,
      circles: widget._circles,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        widget._controller.complete(controller);
      },
    );
  }
}
