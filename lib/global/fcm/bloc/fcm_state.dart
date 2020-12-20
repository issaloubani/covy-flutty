part of 'fcm_bloc.dart';

@immutable
abstract class FcmState extends Equatable {
  const FcmState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FcmInitial extends FcmState {
  const FcmInitial();
}

class FcmInitialization extends FcmState {
  const FcmInitialization();
}

class FcmInitialized extends FcmState {
  const FcmInitialized();
}
