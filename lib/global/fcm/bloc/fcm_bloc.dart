import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:covid_tracker_app/global/firestore/firestore_service.dart';
import 'package:covid_tracker_app/global/ping/bloc/ping_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'fcm_event.dart';

part 'fcm_state.dart';

class FcmBloc extends Bloc<FcmEvent, FcmState> {
  final FirebaseMessaging firebaseMessaging;
  static BuildContext context;
  final FirestoreService firestoreService = FirestoreService();

  FcmBloc(this.firebaseMessaging) : super(FcmInitial());

  @override
  Stream<FcmState> mapEventToState(
    FcmEvent event,
  ) async* {
    if (event is InitializeFCM) {
      context = event.context;
      // register
      await firestoreService.saveDeviceToken();
      // configure fcm
      firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
        try {
          context.bloc<FcmBloc>().add(
                OnMessageEvent(message),
              );
        } catch (e) {
          print("OnMessage : $e");
        }
      }

          // onBackgroundMessage: (Map<String, dynamic> message) async =>
          //     context.bloc<FcmBloc>().add(
          //           OnBackgroundMessageEvent(message),
          //         ),
          // onLaunch: (Map<String, dynamic> message) async =>
          //     context.bloc<FcmBloc>().add(
          //           OnLaunchEvent(message),
          //         ),
          // onResume: (Map<String, dynamic> message) async =>
          //     context.bloc<FcmBloc>().add(
          //           OnResumeEvent(message),
          //         ),
          );
    }

    // messages event
    if (event is OnMessageEvent) {
      if (event.hasData() && event.isPing()) {
        // Scaffold.of(context)
        //     .showSnackBar(SnackBar(content: Text("This is a ping message !")));
        context.bloc<PingBloc>().add(ReceivePing(event.getData()));
      }
    }
  }
}
