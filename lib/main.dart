import 'package:covid_tracker_app/global/chatbot/bloc/chat_bot_bloc.dart';
import 'package:covid_tracker_app/global/chatbot/chatbot_service.dart';
import 'package:covid_tracker_app/global/notificaiton/bloc/notification_bloc.dart';
import 'package:covid_tracker_app/global/notificaiton/notifcation_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';

import 'global/covid/bloc/covid_bloc.dart';
import 'global/covid/covid_service.dart';
import 'global/fcm/bloc/fcm_bloc.dart';
import 'global/fcm/fcm_service.dart';
import 'global/firestore/firestore_service.dart';
import 'global/language/bloc/language_bloc.dart';
import 'global/language/language_service.dart';
import 'global/location/bloc/location_bloc.dart';
import 'global/location/location_service.dart';
import 'global/ping/bloc/ping_bloc.dart';
import 'global/ping/ping_service.dart';
import 'res.dart';
import 'ui/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EasyLocalization(
      supportedLocales: supportedLocales.values.toList(),
      path: pathToLocale, // <-- change patch to your
      fallbackLocale: fallbackLocale,
      child: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocationBloc(LocationService(Location())),
        ),
        BlocProvider(create: (_) => CovidBloc(CovidService())),
        BlocProvider(create: (_) => FcmBloc(FirebaseMessaging())),
        BlocProvider(
            create: (_) =>
                PingBloc(PingService(FCMService(), FirestoreService()))),
        BlocProvider(
            create: (_) =>
                LanguageBloc(EasyLocalization.of(context).locale.languageCode)),
        BlocProvider(
            create: (_) =>
                NotificationBloc(NotificationService())),
        BlocProvider(
            create: (_) => ChatBotBloc(ChatBotService(Res.bot_service)))
      ],
      child: buildMaterialApp(context),
    );
  }

  Widget buildMaterialApp(context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: const Color(0xff222B45),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          EasyLocalization.of(context).delegate,
        ],
        supportedLocales: EasyLocalization.of(context).supportedLocales,
        locale: EasyLocalization.of(context).locale,
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}
