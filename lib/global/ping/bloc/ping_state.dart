part of 'ping_bloc.dart';

@immutable
abstract class PingState extends Equatable {
  const PingState();

  @override
  List<Object> get props => [];
}

class PingInitial extends PingState {
  const PingInitial();
}

class PingActive extends PingState {
  const PingActive();
}

class PingFinished extends PingState {
  const PingFinished();
}
//
// class PingResult extends PingState {
//   const PingResult();
// }
