part of 'chat_bot_bloc.dart';

@immutable
abstract class ChatBotEvent extends Equatable {
  const ChatBotEvent();

  @override
  List<Object> get props => [];
}

class GetChatBotResponse extends ChatBotEvent {
  final String message;

  const GetChatBotResponse(this.message);

  @override
  List<Object> get props => [message];
}
