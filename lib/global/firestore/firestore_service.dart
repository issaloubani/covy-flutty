import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SaveDeviceTokenException implements Exception {
  final String message;

  const SaveDeviceTokenException(this.message) : super();
}

class FirestoreService {
  final CollectionReference tokensDB =
      FirebaseFirestore.instance.collection('tokens');

  FirestoreService();

  Future<DocumentReference> getCurrentDeviceProfile() async {
    return tokensDB.doc(await FirebaseMessaging().getToken());
  }

  Future<DocumentReference> getDeviceProfile(String token) async {
    return tokensDB.doc(token);
  }

  CollectionReference getMeetingCollection(DocumentReference deviceProfile) {
    return deviceProfile.collection('met');
  }

  CollectionReference getNotificationCollection(
      DocumentReference deviceProfile) {
    return deviceProfile.collection('notification');
  }

  Future<void> saveDeviceToken() async {
    String token = await FirebaseMessaging().getToken();
    // try {
    //   await tokens.doc(token).set({'token': '$token'});
    // } catch (e) {
    //   throw SaveDeviceTokenException(e.toString());
    // }
    await tokensDB.doc(token).set({
      'token': '$token',
      'date': '${DateTime.now().millisecondsSinceEpoch}'
    }).catchError((error) {
      throw SaveDeviceTokenException(error.toString());
    });
  }

  Future<List<String>> getDevicesToken() async {
    QuerySnapshot querySnapshot = await tokensDB.get();
    List<String> ids = querySnapshot.docs
        .asMap()
        .map((key, value) => MapEntry(key, value.id))
        .values
        .toList();
    return ids;
  }
}
