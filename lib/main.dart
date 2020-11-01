import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker_app/res.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:string_validator/string_validator.dart';
import 'modules/MessageSender.dart';
import 'ui/pages/main_page.dart';

const int BROADCAST_TIMEOUT = 2;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations', // <-- change patch to your
      fallbackLocale: Locale('en'),
      child: MainApp()));
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return App();
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static final FirebaseMessaging _fcm = FirebaseMessaging();
  CollectionReference tokens = FirebaseFirestore.instance.collection('tokens');
  static CollectionReference met;

  static Location location = new Location();
  String locationStr = "";
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  Future<String> _initMeetingRef() async {
    met = FirebaseFirestore.instance
        .collection('tokens')
        .doc(await _fcm.getToken())
        .collection('met');
  }

  static Future<LocationData> _getCurrentLocation() {
    return location.getLocation();
  }

  Future<LocationData> _initLocation(
      {Function(LocationData) onComplete}) async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    onComplete(await location.getLocation());
    return location.getLocation();
  }

  Widget _placeholderWidget(String value) {
    switch (value.toLowerCase()) {
      case "loading":
        return Text("Loading...");
        break;
      case "error":
        return Text("Something Went Wrong...");
        break;
      default:
        return Text("Something as a placeholder text....");
        break;
    }
  }

  Future<void> _saveDeviceToken() async {
    String deviceToken = await _fcm.getToken();
    await tokens.doc(deviceToken).set({'token': '$deviceToken'});
  }

  static double _calculateDistance(LatLng init, LatLng sender) {
    final Distance distance = Distance();
    // meter = 422591.551
    final double meter = distance(init, sender);
    return meter;
  }

  static Future<dynamic> _onBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("OnBackgroundMessage : $message");
    // String msg = "postwoman";
    // if (message['data']['message'] == msg) {
    //   try {
    //     Map<String, dynamic> data = Map.from(message['data']);
    //     data['blah'] = "blahh";
    //     data['message'] = 'postboy';
    //     var msgSent = {"data": data, "to": "${await _fcm.getToken()}"};
    //     MessageSender.sendMessage(msgSent);
    //   } catch (e) {
    //     print('error $e');
    //   }
    // }
    if (message['data']['sender'] != null &&
        message['data']['sender'] != await _fcm.getToken()) {
      // not send by the same device
      _checkBroadcast(message);
    }
  }

  static Future<dynamic> _onMessageHandler(Map<String, dynamic> message) async {
    print("OnMessage : $message");
    if (message['data']['sender'] != null &&
        message['data']['sender'] != await _fcm.getToken()) {
      // not send by the same device
      _checkBroadcast(message);
    }
  }

  static Future<void> _checkBroadcast(Map<String, dynamic> message) async {
    try {
      String currentDeviceToken = await _fcm.getToken();
      if (message['data']['response'] != null) {
        // if message contains response flag
        bool response = toBoolean(message['data']['response']);
        var sender = message['data']['sender'];

        if (response) {
          print("Response received from $sender");
          // check if contains a secret key
        } else {
          print("Sending response to ${message['data']['sender']}");
          // check location distance between currentDevice and sender
          double la = double.tryParse(message['data']['la']); // sender latitude
          double lo =
              double.tryParse(message['data']['lo']); // sender longitude
          LocationData currentLocation = await _getCurrentLocation();
          print(
              "Fetched Coordinates : Lat:${currentLocation.latitude} , Lo:${currentLocation.longitude}");
          double distance = _calculateDistance(
              LatLng(currentLocation.latitude, currentLocation.longitude),
              LatLng(la,
                  lo)); // distance from current location and sender in meters
          print("Total distance: $distance");
          if (distance < 2) {
            // send response back
            MessageSender.sendResponseMessage(
                from: currentDeviceToken, to: message['data']['sender']);
            await met.add({
              "token": message['data']['sender'],
              "date": DateTime.now(),
              "la": currentLocation.latitude,
              "lo": currentLocation.longitude,
            });
          } // ignore the broadcast message

        }
      }
    } catch (e) {
      print("Error in Check broadcast: $e");
    }
  }

  @override
  void initState() {
    print("Main App initialization");
    _initMeetingRef();
    _saveDeviceToken();
    _initLocation(onComplete: (location) {
      // init send
      _fcm.getToken().then((currentDeviceToken) => {
            tokens.get().then((QuerySnapshot querySnapshot) {
              List<String> ids = querySnapshot.docs
                  .asMap()
                  .map((key, value) => MapEntry(key, value.id))
                  .values
                  .toList();

              //   Timer.periodic(Duration(seconds: 10), (timer) {
              MessageSender.sendPingBroadcast(
                  response: false,
                  registrationsId: ids,
                  la: location.latitude,
                  lo: location.longitude,
                  from: currentDeviceToken);
              //   });
            })
          });

      // repeat
      Future.delayed(Duration(minutes: BROADCAST_TIMEOUT), () {
        Timer.periodic(Duration(minutes: BROADCAST_TIMEOUT), (timer) {
          _getCurrentLocation().then((location) {
            _fcm.getToken().then((currentDeviceToken) => {
                  tokens.get().then((QuerySnapshot querySnapshot) {
                    List<String> ids = querySnapshot.docs
                        .asMap()
                        .map((key, value) => MapEntry(key, value.id))
                        .values
                        .toList();

                    //   Timer.periodic(Duration(seconds: 10), (timer) {
                    MessageSender.sendPingBroadcast(
                        response: false,
                        registrationsId: ids,
                        la: location.latitude,
                        lo: location.longitude,
                        from: currentDeviceToken);
                    //   });
                  })
                });
          });
        });
      });
    });
    _fcm.configure(
      onBackgroundMessage: _onBackgroundMessageHandler,
      onMessage: _onMessageHandler,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          EasyLocalization.of(context).delegate,
        ],
        supportedLocales: EasyLocalization.of(context).supportedLocales,
        locale: EasyLocalization.of(context).locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.green[400]),
        home: FutureBuilder(
          // Initialize FlutterFire:
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return _placeholderWidget("error");
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return MainPage();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return Scaffold(
              body: Center(child: Lottie.asset(Res.splash_anim)),
            );
          },
        ));
  }
}
