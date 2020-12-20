part of 'ping_bloc.dart';

@immutable
abstract class PingEvent extends Equatable {
  const PingEvent();

  @override
  List<Object> get props => [];
}

class BeginPingEvent extends PingEvent {
  final LocationData locationData;

  const BeginPingEvent(this.locationData);

  @override
  List<Object> get props => [locationData];
}

class UpdateLocationPingEvent extends PingEvent {
  final LocationData locationData;

  const UpdateLocationPingEvent(this.locationData);

  @override
  List<Object> get props => [locationData];
}

class SendPing extends PingEvent {
  const SendPing();
}

class PingAllDevices extends PingEvent {
  const PingAllDevices();
}

class ReceivePing extends PingEvent {
  final Map<dynamic, dynamic> data;

  const ReceivePing(this.data);

  @override
  List<Object> get props => [data];
}
