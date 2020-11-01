import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class MessageSender {
  static final _baseURL = "https://fcm.googleapis.com/fcm/send";
  static const String apiKey =
      "AAAA6INuxKY:APA91bEjtSYaIhhnH1HimosYH-xUAuIwANzEt3CJ4wdjhxHukK8Nop0abZ3bwlfbyUtrlIY9ezZNBCRHIgJOlBOb2nU_0kPaH4wTVsXPzeSgN8WaAmkYaKNOftzwb7LdZUN646menlsb";

  static final headers = {
    'content-type': 'application/json',
    'Authorization': 'key=$apiKey'
  };

  static Future<void> _sendMessage({data, headers}) async {
    try {
      print("Send Data : $data");
      final response = await http.post(_baseURL,
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        print("Request Sent");
      } else {
        print('notification sending failed : ${response.body}');
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
    }
  }

  static sendPingBroadcast({@required String from,
    @required List<String> registrationsId,
    @required bool response,
    @required double la,
    @required double lo}) {
    final data = {
      "data": {
        "sender": "$from",
        "la": la,
        "lo": lo,
        "response": response,
      },
      "registration_ids": registrationsId
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$apiKey'
    };
    _sendMessage(data: data, headers: headers);
  }

  static Future<void> sendMessage(Map<String, dynamic> data) {
    _sendMessage(data: data, headers: headers);
  }

  static sendBroadcastMessage(
      {@required String from, @required String to, @required bool response}) {
    final data = {
      //  "notification": {"body": "Test", "title": "Test",  "click_action": "FLUTTER_NOTIFICATION_CLICK"},

      "data": {
        "sender": "$from",
        "response": response,
      },

      "to": "$to"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$apiKey'
    };
    _sendMessage(data: data, headers: headers);
  }

  static sendBroadcastMessages({@required String from,
    List<String> registrationsId,
    @required bool response}) {
    final data = {
      //  "notification": {"body": "Test", "title": "Test",  "click_action": "FLUTTER_NOTIFICATION_CLICK"},

      "data": {
        "sender": "$from",
        "response": response,
      },

      "registration_ids": registrationsId
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$apiKey'
    };

    _sendMessage(data: data, headers: headers);
  }

  static sendResponseMessage({@required String from, @required String to}) {
    sendBroadcastMessage(from: from, to: to, response: true);
  }

  static sendCustomMessage(String token, Map<dynamic, dynamic> data) {
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$apiKey'
    };
    data['to'] = token;
    _sendMessage(data: data, headers: headers);
  }
}
