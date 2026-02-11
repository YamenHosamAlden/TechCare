import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/features/user_preferences/domain/usecases/change_app_language_usecase.dart';
import 'package:tech_care_app/features/user_preferences/domain/usecases/get_user_preferences_usecase.dart';

import '../../../../core/util/app_themes.dart';

part 'user_preferences_event.dart';
part 'user_preferences_state.dart';

class UserPreferencesBloc
    extends Bloc<UserPreferencesEvent, UserPreferencesState> {
  final ChangeAppLanguageUsecase changeLanguageUsecase;
  final GetUserPreferenceUsecase getUserPreferenceUsecase;

  UserPreferencesBloc({
    required this.changeLanguageUsecase,
    required this.getUserPreferenceUsecase,
  }) : super(UserPreferencesInitialState()) {
    on<UserPreferencesInitialEvent>(_onUserPreferencesInitialEvent);
    on<UserPreferredLanguageChanged>(_onUserPreferredLanguageChanged);
    on<UserPreferredThemeChanged>(_onUserPreferredThemeChanged);
  }

  Future<void> _onUserPreferencesInitialEvent(
    UserPreferencesInitialEvent event,
    Emitter<UserPreferencesState> emit,
  ) async {
    await getUserPreferenceUsecase(Void)
        .then((value) => value.fold((failure) {}, (userPreferences) {
              emit(UserPreferencesState(
                  locale: userPreferences.locale, theme: AppTheme.lightTheme));
            }));
  }

  Future<void> _onUserPreferredLanguageChanged(
    UserPreferredLanguageChanged event,
    Emitter<UserPreferencesState> emit,
  ) async {
    changeLanguageUsecase(Params(locale: event.locale));

    emit(state.copyWith(locale: event.locale));
  }

  Future<void> _onUserPreferredThemeChanged(
    UserPreferredThemeChanged event,
    Emitter<UserPreferencesState> emit,
  ) async {}
}
