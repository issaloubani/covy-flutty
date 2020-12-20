import 'package:flutter_dialogflow/dialogflow_v2.dart';

import '../../res.dart';

class ChatBotService {
  final String jsonFilePath;

 const ChatBotService(this.jsonFilePath);

  Future<String> response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(fileJson: this.jsonFilePath).build();
    Dialogflow dialogFlow =
    Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogFlow.detectIntent(query);
    // print("AiResponse ${aiResponse.getMessage()}");
    // String response = aiResponse.getListMessage().length == 1
    //     ? aiResponse.getListMessage()[0]["text"]["text"][0]
    //     : aiResponse.getListMessage()[1]["text"]["text"][0];
    return aiResponse.getMessage() ?? "I can't understand";
  }
}

