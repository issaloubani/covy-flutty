part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final AppTheme theme;

  const ChangeTheme(this.theme);

  @override
  List<Object> get props => [theme];
}
