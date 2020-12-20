part of 'notification_bloc.dart';

@immutable
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}
class NotificationLoading extends NotificationState {
  const NotificationLoading();
}
class NotificationLoaded extends NotificationState {
 final QuerySnapshot notificationSnapshots;
  const NotificationLoaded(this. notificationSnapshots);

  @override
  List<Object> get props => [notificationSnapshots];
}
class PresentNotification extends NotificationState {
  final Map<dynamic, dynamic> message;

  const PresentNotification(this.message);

  @override
  List<Object> get props => [message];
}

class DismissNotification extends NotificationState {
  const DismissNotification();
}
