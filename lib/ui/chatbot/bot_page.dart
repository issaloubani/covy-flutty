import 'package:covid_tracker_app/global/chatbot/bloc/chat_bot_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../res.dart';

enum Chatter { Bot, User }

class ChatBotPage extends StatefulWidget {
  ChatBotPage({Key key}) : super(key: key);

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  TextEditingController textFieldController = TextEditingController();
  List<Map> messages = new List();

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
      appBar: buildAppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildDate(),
            BlocListener<ChatBotBloc,ChatBotState>(
                listener: (BuildContext context, state) {
                  if (state is ChatBotLoading) {
                    setState(() {
                      messages
                          .insert(0, {"data": Chatter.Bot, "message": "..."});
                    });
                  } else if (state is ChatBotLoaded) {
                    setState(() {
                      messages.removeAt(0);
                      messages.insert(
                          0, {"data": Chatter.Bot, "message": state.response});
                    });
                  }
                },
                child: buildChatList()),
            buildDivider(),
            buildInputField(context),
          ],
        ),
      ),
    );
  }

  Center buildDate() {
    return Center(
        child: Container(
      child: Text(
        "Today, ${DateFormat("HH:MM").format(DateTime.now())}",
        style: TextStyle(
          fontSize: 25.0,
        ),
      ),
      padding: EdgeInsets.all(15.0),
    ));
  }

  Flexible buildChatList() {
    return Flexible(
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) => buildChat(
            context, messages[index]["message"], messages[index]["data"]),
      ),
    );
  }

  Container buildInputField(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        trailing: IconButton(
          onPressed: onSendBtnPressed,
          icon: Icon(
            Icons.send_rounded,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: TextField(
            controller: textFieldController,
            decoration: InputDecoration(
              hintText: 'Enter your message',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
            )),
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      thickness: 1,
    );
  }

  AppBar buildAppBar() {
    return AppBar(

        centerTitle: true,
        title: Text("Covy"));
  }

  void onSendBtnPressed() {
    if (textFieldController.text.isEmpty) {
    } else {
      setState(() {
        messages.insert(
            0, {"data": Chatter.User, "message": textFieldController.text});
      });
      // response(textFieldController.text);
      context
          .bloc<ChatBotBloc>()
          .add(GetChatBotResponse(textFieldController.text));
      textFieldController.clear();
    }
  }
}

Widget buildChat(BuildContext context, String message, Chatter chatter) {
  return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: ListTile(
        leading: chatter == Chatter.Bot
            ? CircleAvatar(child: SvgPicture.asset(Res.pastel_robot))
            : null,
        trailing: chatter == Chatter.User
            ? CircleAvatar(child: SvgPicture.asset(Res.user))
            : null,
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
