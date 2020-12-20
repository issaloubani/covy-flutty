part of 'fcm_bloc.dart';

@immutable
abstract class FcmEvent extends Equatable {
  const FcmEvent();

  @override
  List<Object> get props => [];
}

class InitializeFCM extends FcmEvent {
  final BuildContext context;

  const InitializeFCM(this.context);

  @override
  List<Object> get props => [context];
}

abstract class MessageEvent extends FcmEvent {
  final Map<String, dynamic> message;

  const MessageEvent(this.message);

  @override
  List<Object> get props => [message];

  Map<dynamic, dynamic> getData() => this.message['data'];

  Map<dynamic, dynamic> getNotification() {
    return this.message["notification"];
  }

  bool hasData() {
    return this.getData() != null;
  }

  bool hasNotification() {
    return this.getNotification() != null;
  }

  String getProtocol() {
    print("Runtime value: ${getData()["protocol"]}");
    return getData()["protocol"] ?? "not ping";
  }

  bool isPing() {
    return getProtocol().toLowerCase() == "ping";
  }
}

class OnMessageEvent extends MessageEvent {
  const OnMessageEvent(Map<String, dynamic> message) : super(message);

  @override
  List<Object> get props => super.props;
}

class OnResumeEvent extends MessageEvent {
  const OnResumeEvent(Map<String, dynamic> message) : super(message);

  @override
  List<Object> get props => super.props;
}

class OnLaunchEvent extends MessageEvent {
  const OnLaunchEvent(Map<String, dynamic> message) : super(message);

  @override
  List<Object> get props => super.props;
}

class OnBackgroundMessageEvent extends MessageEvent {
  OnBackgroundMessageEvent(Map<String, dynamic> message) : super(message);

  @override
  List<Object> get props => super.props;
}
