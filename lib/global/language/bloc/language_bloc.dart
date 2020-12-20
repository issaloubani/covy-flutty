import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../language_service.dart';

part 'language_event.dart';

part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final String languageCode;

  LanguageBloc(this.languageCode) : super(LanguageState(languageCode));

  @override
  Stream<LanguageState> mapEventToState(
    LanguageEvent event,
  ) async* {
    if (event is ChangeLanguage) {
      // change language
      EasyLocalization.of(event.context).locale =
          supportedLocales[event.language];
      yield LanguageState(languageCode);
    }
  }
}
