import 'package:covid_tracker_app/global/fcm/fcm_service.dart';
import 'package:covid_tracker_app/global/firestore/firestore_service.dart';
import 'package:location/location.dart';

class PingService {
  final FCMService fcmService;
  final FirestoreService firestoreService;

  const PingService(this.fcmService, this.firestoreService);

//  void sendPing() {}

  void pingAllDevices(LocationData locationData) async {
    String token = await fcmService.getDeviceToken();
    List<String> allTokens = await firestoreService.getDevicesToken();

    fcmService.sendPingBroadcast(
      from: token,
      registrationsId: allTokens,
      response: false,
      la: locationData.latitude,
      lo: locationData.longitude,
    );
  }
}
