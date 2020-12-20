part of 'language_bloc.dart';

@immutable
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguage extends LanguageEvent {
  final SupportedLanguages language;
  final BuildContext context;

  const ChangeLanguage({@required this.language, @required this.context});

  @override
  List<Object> get props => [language, context];
}
