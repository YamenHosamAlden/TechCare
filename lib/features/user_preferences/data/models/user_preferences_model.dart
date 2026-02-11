import 'package:flutter/material.dart';
import 'package:tech_care_app/features/user_preferences/domain/entities/user_preferences.dart';

const String LANGUAGE_KEY = 'language_code';

class UserPreferencesModel extends UserPreferences {
  UserPreferencesModel({required super.locale});

  UserPreferencesModel.fromEntity(UserPreferences userPreferences)
      : this(locale: userPreferences.locale);

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(locale: Locale(json[LANGUAGE_KEY]));
  }

  toJson() {
    return {
      LANGUAGE_KEY: locale.languageCode,
    };
  }
}
