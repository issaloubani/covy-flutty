import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

import '../ping_service.dart';

part 'ping_event.dart';

part 'ping_state.dart';

class PingBloc extends Bloc<PingEvent, PingState> {
  final PingService pingService;
  static LocationData locationData = LocationData.fromMap({
    'latitude': 0,
    'longitude': 0,
    'accuracy': 0,
    'altitude': 0,
    'speed': 0,
    'speed_accuracy': 0,
    'heading': 0,
    'time': 0,
  });

  PingBloc(this.pingService) : super(PingInitial());

  @override
  Stream<PingState> mapEventToState(
    PingEvent event,
  ) async* {
    if (event is BeginPingEvent) {
      // init location
      locationData = event.locationData;
    } else if (event is UpdateLocationPingEvent) {
      locationData = event.locationData;
    }

    if (event is PingAllDevices) {
      yield PingActive();
      // send ping to device/s
      pingService.pingAllDevices(locationData);
      // await
      yield PingFinished();
    }

    if (event is ReceivePing) {
      //  yield PingResult();
      double la = event.data['la'];
      double lo = event.data['lo'];
      double distance = _calculateDistance(
          LatLng(locationData.latitude, locationData.longitude),
          LatLng(la, lo)); //

      if (distance < 2) {
        // notify the user and save the result
        await saveForeignDevice(event);
      }
      // else do nothing he is far away
    }
  }

  Future saveForeignDevice(ReceivePing event) async {
    double la = event.data['la'];
    double lo = event.data['lo'];
    DocumentReference profile =
        await pingService.firestoreService.getCurrentDeviceProfile();
    CollectionReference met =
        pingService.firestoreService.getMeetingCollection(profile);
    met.add({
      'token': event.data['sender'],
      'la': la,
      'lo': lo,
      'date': DateTime.now().millisecondsSinceEpoch
    });
  }

  double _calculateDistance(LatLng init, LatLng sender) {
    final Distance distance = Distance();
    // meter = 422591.551
    final double meter = distance(init, sender);
    return meter;
  }
}
