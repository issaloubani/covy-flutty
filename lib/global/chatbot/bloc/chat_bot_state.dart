part of 'chat_bot_bloc.dart';

@immutable
abstract class ChatBotState extends Equatable {
  const ChatBotState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ChatBotInitial extends ChatBotState {
  const ChatBotInitial();
}

class ChatBotLoading extends ChatBotState {
  const ChatBotLoading();
}

class ChatBotLoaded extends ChatBotState {
  final String response;

  const ChatBotLoaded(this.response);

  @override
  List<Object> get props => [response];
}

class ChatBotError extends ChatBotState {
  final Exception e;

  const ChatBotError(this.e);

  @override
  List<Object> get props => [e];
}
