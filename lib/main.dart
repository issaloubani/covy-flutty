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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';

import 'common/custom_exceptions.dart';
import 'modules/MessageSender.dart';
import 'ui/pages/language_page.dart';
import 'ui/pages/main_page.dart';

const int BROADCAST_TIMEOUT = 2;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations', // <-- change patch to your
      fallbackLocale: Locale('en'),
      child: App()));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static final FirebaseMessaging _fcm = FirebaseMessaging();
  CollectionReference tokens = FirebaseFirestore.instance.collection('tokens');
  static CollectionReference met;
  SharedPreferences sharedPreferences;
  static Location location = new Location();
  String deviceToken = "";
  bool _serviceEnabled;
  LocationData locationData;
  PermissionStatus _permissionGranted;
  GlobalKey<MainPageState> mainPageKey = GlobalKey<MainPageState>();

  Future<void> createMetRef(String token) async {
    met = FirebaseFirestore.instance
        .collection('tokens')
        .doc(token)
        .collection('met');
  }

  static Future<LocationData> _getCurrentLocation() {
    return location.getLocation();
  }

  Future<LocationData> initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {}
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw LocationDeniedException();
      }
    }

    if (_permissionGranted == PermissionStatus.deniedForever) {
      throw LocationDeniedForeverException();
    }

    return location.getLocation();
  }

  Future<void> saveDeviceToken(String token) async {
    await tokens.doc(token).set({'token': '$token'}).catchError((error) {
      throw Exception(error.toString());
    });
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
    if (message['data']['sender'] != null &&
        message['data']['sender'] != await _fcm.getToken()) {
      // not send by the same device
      _checkBroadcast(message);
    }
  }

  Future<dynamic> _onMessageHandler(Map<String, dynamic> message) async {
    print("OnMessage : $message");
    if (message['data']['sender'] != null &&
        message['data']['sender'] != await _fcm.getToken()) {
      // not send by the same device
      _checkBroadcast(message);
    }

    print("Animation Triggered!!");
    mainPageKey.currentState.controller.reset();
    mainPageKey.currentState.controller.forward();
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
        theme: ThemeData(primaryColor: Colors.green[400],cursorColor: Colors.green[500]),
        home: FutureBuilder(
          // Initialize FlutterFire:
          future: _initApp(),
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Scaffold(
                  body: Center(
                      child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(Res.error_anim),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("location_error".tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  RaisedButton(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => App(),
                          )),
                      child: Text(
                        "okay".tr(),
                        style: Theme.of(context).accentTextTheme.button,
                      ),
                      color: Colors.green)
                ],
              )));
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              if (sharedPreferences.containsKey('opened')) {
                return MainPage(
                  locationData: locationData,
                  key: mainPageKey,
                );
              }

              return LanguagePage(
                context: context,
                locationData: locationData,
                mainPageKey: mainPageKey,
              );
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return Scaffold(
              body: Center(
                child: Lottie.asset(
                  Res.splash_anim,
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
              ),
            );
          },
        ));
  }

  Future<void> _initApp() async {
    // get device token
    deviceToken = await _fcm.getToken();
    await createMetRef(deviceToken);
    await saveDeviceToken(deviceToken);
    locationData = await initLocation();
    _initFCMMessages(locationData, deviceToken);
    sharedPreferences = await SharedPreferences.getInstance();
  }

  _initFCMMessages(LocationData location, String token) {
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
          from: token);
    });

    Future.delayed(Duration(minutes: BROADCAST_TIMEOUT), () {
      Timer.periodic(Duration(minutes: BROADCAST_TIMEOUT), (timer) {
        _getCurrentLocation().then((location) {
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
                from: token);
            //   });
          });
        });
      });
      _fcm.configure(
        onBackgroundMessage: _onBackgroundMessageHandler,
        onMessage: _onMessageHandler,
      );
    });
  }
}
