import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_svg/svg.dart';

import '../../res.dart';

enum Chatter { Bot, User }

class BotPage extends StatefulWidget {
  BotPage({Key key}) : super(key: key);

  @override
  _BotPageState createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  TextEditingController textFieldController = TextEditingController();
  List<Map> messages = new List();

  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(fileJson: Res.bot_service).build();
    Dialogflow dialogFlow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogFlow.detectIntent(query);
    print("Response: ${response.getListMessage()}");
    String responseMsg = response.getListMessage().length == 1
        ? response.getListMessage()[0]["text"]["text"][0]
        : response.getListMessage()[1]["text"]["text"][0];
    setState(() {
      messages.insert(0, {"data": Chatter.Bot, "message": responseMsg});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messages.insert(0, {
      "data": Chatter.Bot,
      "message": "Hello, my name is Covy 😁✌ !"
          " You can ask me anything related to COVID-19."
    });
    messages.insert(0, {
      "data": Chatter.Bot,
      "message":
          "You can start by asking about its symptoms and ways of prevention."
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
        title: Text("Covy")
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Container(
              child: Text(
                "Today, ${DateFormat("HH:MM").format(DateTime.now())}",
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              padding: EdgeInsets.all(15.0),
            )),
            Flexible(
              child: ListView.builder(

                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) => chat(context,
                    messages[index]["message"], messages[index]["data"]),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListTile(
                trailing: IconButton(
                  onPressed: () {
                    if (textFieldController.text.isEmpty) {
                    } else {
                      setState(() {
                        messages.insert(0, {
                          "data": Chatter.User,
                          "message": textFieldController.text
                        });
                      });
                      response(textFieldController.text);
                      textFieldController.clear();
                    }
                  },
                  icon: Icon(
                    Icons.send_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: TextField(
                    controller: textFieldController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget chat(BuildContext context, String message, Chatter chatter) {
  return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: ListTile(
        leading: chatter == Chatter.Bot ? CircleAvatar(child: SvgPicture.asset(Res.robot)): null,
        trailing: chatter == Chatter.User ? CircleAvatar(child: SvgPicture.asset(Res.user)): null,
        title: Align(
            alignment: chatter == Chatter.Bot
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: chatter == Chatter.Bot
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
            )),
      ));
}
