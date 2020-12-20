part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GotNotification extends NotificationEvent {
  final Map<dynamic, dynamic> message;

  const GotNotification(this.message);

  @override
  List<Object> get props => [message];
}
