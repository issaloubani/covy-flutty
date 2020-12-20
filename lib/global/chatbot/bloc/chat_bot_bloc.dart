import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covid_tracker_app/global/chatbot/chatbot_service.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../chatbot_service.dart';

part 'chat_bot_event.dart';

part 'chat_bot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  final ChatBotService chatBotService;

  ChatBotBloc(this.chatBotService) : super(ChatBotInitial());

  @override
  Stream<ChatBotState> mapEventToState(
    ChatBotEvent event,
  ) async* {
    if (event is GetChatBotResponse) {
      try {
        yield ChatBotLoading();
        String message = event.message;
        String response = await chatBotService.response(message);
        yield ChatBotLoaded(response);
      } catch (e) {
        print("ChatBotError $e");
        yield ChatBotError(e);
      }
    }
  }
}
