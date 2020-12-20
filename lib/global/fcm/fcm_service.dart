import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

class SendMessageException implements Exception {}

class FCMService {
  final Dio dio = Dio();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  static const _baseURL = "https://fcm.googleapis.com/fcm/send";
  static const String apiKey =
      'AAAA6INuxKY:APA91bEjtSYaIhhnH1HimosYH-xUAuIwANzEt3CJ4wdjhxHukK8Nop0abZ3bwlfbyUtrlIY9ezZNBCRHIgJOlBOb2nU_0kPaH4wTVsXPzeSgN8WaAmkYaKNOftzwb7LdZUN646menlsb';

   final headers = {
    'content-type': 'application/json',
    'Authorization': 'key=$apiKey'
  };

  Future<String> getDeviceToken() {
    return firebaseMessaging.getToken();
  }

  Future<void> _sendMessage({data, headers}) async {

    print("Send Data : $data");
    final response = await dio.post(
      _baseURL,
      data: json.encode(data),
      //  encoding: Encoding.getByName('utf-8'),
      options: Options(
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      print("Request Sent");
    } else {
      //   print('notification sending failed : ${response.data}');
      // on failure do sth
      throw SendMessageException();
    }
  }

  void sendPingBroadcast(
      {@required String from,
      @required List<String> registrationsId,
      @required bool response,
      @required double la,
      @required double lo}) {
    final data = {
      "data": {
        "protocol": "ping",
        "sender": "$from",
        "la": la,
        "lo": lo,
        "response": response,
      },
      "registration_ids": registrationsId
    };

    // final headers = {
    //   'content-type': 'application/json',
    //   'Authorization': 'key=$apiKey'
    // };

    _sendMessage(data: data, headers: headers);
  }

  void sendBroadcastMessage(
      {@required String from, @required String to, @required bool response}) {
    final data = {
      //  "notification": {"body": "Test", "title": "Test",  "click_action": "FLUTTER_NOTIFICATION_CLICK"},

      "data": {
        "sender": "$from",
        "response": response,
      },

      "to": "$to"
    };

    // final headers = {
    //   'content-type': 'application/json',
    //   'Authorization': 'key=$apiKey'
    // };
    _sendMessage(data: data, headers: headers);
  }

  void sendBroadcastMessages(
      {@required String from,
      @required List<String> registrationsId,
      @required bool response}) {
    final data = {
      //  "notification": {"body": "Test", "title": "Test",  "click_action": "FLUTTER_NOTIFICATION_CLICK"},

      "data": {
        "sender": "$from",
        "response": response,
      },

      "registration_ids": registrationsId
    };

    // final headers = {
    //   'content-type': 'application/json',
    //   'Authorization': 'key=$apiKey'
    // };

    _sendMessage(data: data, headers: headers);
  }

  void sendResponseMessage({@required String from, @required String to}) {
    sendBroadcastMessage(from: from, to: to, response: true);
  }

  void sendCustomMessage(String token, Map<dynamic, dynamic> data) {
    // final headers = {
    //   'content-type': 'application/json',
    //   'Authorization': 'key=$apiKey'
    // };
    data['to'] = token;
    _sendMessage(data: data, headers: headers);
  }
}
