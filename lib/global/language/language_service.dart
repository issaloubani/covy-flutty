import 'package:flutter/material.dart';

enum SupportedLanguages {
  English,
  Arabic,
}
// Important :
// When Adding a locale don't forget to add the [language_code].json in the locale path
const Map<SupportedLanguages, Locale> supportedLocales = {
  SupportedLanguages.English: Locale('en'),
  SupportedLanguages.Arabic: Locale('ar')
};

const String pathToLocale = 'assets/translations';
final Locale fallbackLocale = supportedLocales[SupportedLanguages.English];
