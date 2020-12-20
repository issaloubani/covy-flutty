import 'package:covid_tracker_app/global/language/bloc/language_bloc.dart';
import 'package:covid_tracker_app/global/language/language_service.dart';
import 'package:covid_tracker_app/res.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<SupportedLanguages, dynamic> map = {
      SupportedLanguages.English: ["english".tr(), Res.america_flag],
      SupportedLanguages.Arabic: ["arabic".tr(), Res.lebanon_flag],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("languages".tr()),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => buildLanguageUI(
            context: context,
            image: map.values.toList()[index][1],
            language: map.keys.toList()[index],
            text: map.values.toList()[index][0]),
        itemCount: 2,
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );
  }

  void changeLanguageOnPressed(
    BuildContext context,
    SupportedLanguages language,
  ) {
    context.bloc<LanguageBloc>().add(ChangeLanguage(
          language: language,
          context: context,
        ));
  }

  Widget buildLanguageUI(
      {BuildContext context,
      String text,
      SupportedLanguages language,
      String image}) {
    return ListTile(
      onTap: () => changeLanguageOnPressed(context, language),
      leading: SvgPicture.asset(
        image,
      ),
      title: Text(
        text,
        //  style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
