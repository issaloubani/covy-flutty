import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker_app/global/firestore/firestore_service.dart';
import 'package:covid_tracker_app/global/notificaiton/notifcation_service.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;
  FirestoreService firestoreService = FirestoreService();

  NotificationBloc(this.notificationService) : super(NotificationInitial());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if(event is GetNotifications){
      yield NotificationLoading();
      CollectionReference notifications =
      firestoreService.getNotificationCollection(
          await firestoreService.getCurrentDeviceProfile());
      QuerySnapshot notificationSnapshots = await notifications.get();
      yield NotificationLoaded(notificationSnapshots);
    }
    if (event is GotNotification) {
      CollectionReference notifications =
          firestoreService.getNotificationCollection(
              await firestoreService.getCurrentDeviceProfile());

      /*
       {
          'notification_title': NOTIFICATION TITLE,
      'notification_data': NOTIFICATION TITLE,
      'date' : DATE IN MILLISECONDS,
      'viewed': TRUE OR FALSE,
      }

      */
      notifications.add({
        'notification_title': event.message['notification_title'],
        'notification_data': event.message['notification_data'],
        'date': DateTime.now().millisecondsSinceEpoch,
        'viewed': false,
      });
 
    }
  }
}
