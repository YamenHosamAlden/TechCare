part of 'user_preferences_bloc.dart';

abstract class UserPreferencesEvent extends Equatable {
  const UserPreferencesEvent();

  @override
  List<Object> get props => [];
}

class UserPreferencesInitialEvent extends UserPreferencesEvent{
}


class UserPreferredLanguageChanged extends UserPreferencesEvent {
  final Locale locale;

  const UserPreferredLanguageChanged({required this.locale});
}

class UserPreferredThemeChanged extends UserPreferencesEvent {
  final AppTheme theme;

  const UserPreferredThemeChanged({required this.theme});
}
