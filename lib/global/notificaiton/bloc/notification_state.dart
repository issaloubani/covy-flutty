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

class PresentNotification extends NotificationState {
  final Map<dynamic, dynamic> message;

  const PresentNotification(this.message);

  @override
  List<Object> get props => [message];
}

class DismissNotification extends NotificationState {
  const DismissNotification();
}
