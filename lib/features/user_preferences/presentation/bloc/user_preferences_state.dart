part of 'user_preferences_bloc.dart';

class UserPreferencesState extends Equatable {
  final AppTheme? theme;
  final Locale? locale;
  const UserPreferencesState({this.theme, this.locale});

  UserPreferencesState copyWith({AppTheme? theme, Locale? locale}) =>
      UserPreferencesState(
        theme: theme ?? this.theme,
        locale: locale ?? this.locale,
      );

  @override
  List<Object?> get props => [theme, locale];
}

class UserPreferencesInitialState extends UserPreferencesState {}
