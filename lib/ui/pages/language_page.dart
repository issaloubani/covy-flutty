import 'package:covid_tracker_app/ui/components/flag_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res.dart';
import 'main_page.dart';

class LanguagePage extends StatefulWidget {
  final BuildContext context;
  final LocationData locationData;
  final Key mainPageKey;

  LanguagePage(
      {Key key,
      @required this.context,
      @required this.locationData,
      @required this.mainPageKey})
      : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

enum Language { arabic, english }

class _LanguagePageState extends State<LanguagePage> {
  GlobalKey<FlagAnimateState> englishFlagKey = GlobalKey<FlagAnimateState>();
  GlobalKey<FlagAnimateState> arabicFlagKey = GlobalKey<FlagAnimateState>();
  SharedPreferences sharedPreferences;
  Language _language;
  String englishTitle, arabicTitle, buttonText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _language = widget.context.locale.languageCode == 'ar'
        ? Language.arabic
        : Language.english;
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
    _updateUIText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlagAnimate(
                      onTab: () => _changeToEnglish(),
                      key: englishFlagKey,
                      image: Res.america_flag,
                    ),
                    Text(englishTitle,
                        style: Theme.of(context).textTheme.headline6),
                    Transform.scale(
                        scale: 2.0,
                        child: Radio(
                          value: Language.english,
                          groupValue: _language,
                          onChanged: (Language value) => _changeToEnglish(),
                        )),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlagAnimate(
                      onTab: () => _changeToArabic(),
                      key: arabicFlagKey,
                      image: Res.lebanon_flag,
                    ),
                    Text(arabicTitle,
                        style: Theme.of(context).textTheme.headline6),
                    Transform.scale(
                      scale: 2.0,
                      child: Radio(
                          value: Language.arabic,
                          groupValue: _language,
                          onChanged: (Language value) => _changeToArabic()),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Transform.scale(
                scale: 2.0,
                child: RaisedButton(
                  onPressed: () {
                    sharedPreferences.setBool("opened", true);
                    context.locale = (_language == Language.arabic)
                        ? Locale('ar')
                        : Locale('en');
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return MainPage(
                            locationData: widget.locationData,
                            key: widget.mainPageKey);
                      },
                    ));
                  },
                  color: Colors.green,
                  child: Text(
                    buttonText,
                    style: Theme.of(context).accentTextTheme.button,
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  void _changeToEnglish() {
    englishFlagKey.currentState.controller.reset();
    englishFlagKey.currentState.controller.forward();
    setState(() {
      // context.locale = Locale('en');
      _language = Language.english;
      _updateUIText();
    });
  }

  void _changeToArabic() {
    arabicFlagKey.currentState.controller.reset();
    arabicFlagKey.currentState.controller.forward();
    setState(() {
      //  context.locale = Locale('ar');
      _language = Language.arabic;
      _updateUIText();
    });
  }

  void _updateUIText() {
    englishTitle = _language == Language.arabic ? "الانجليزية" : "English";
    arabicTitle = _language == Language.arabic ? "الغة العربية" : "Arabic";
    buttonText = _language == Language.arabic ? "حسناً" : "Okay";
  }
}
