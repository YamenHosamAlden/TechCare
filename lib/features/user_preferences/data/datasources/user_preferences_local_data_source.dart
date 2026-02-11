import 'dart:convert';
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_care_app/features/user_preferences/data/models/user_preferences_model.dart';

const CACHED_USER_PREFERENCES = 'user_preferences';

abstract class UserPreferencesLocalDataSource {
  Future<UserPreferencesModel> getCachedUserPreferences();
  Future<void> CacheUserPreferences(UserPreferencesModel userPreferencesModel);
}

class UserPreferencesLocalDataSourceImpl
    extends UserPreferencesLocalDataSource {
  SharedPreferences sharedPreferences;

  UserPreferencesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserPreferencesModel> getCachedUserPreferences() {
    String? userPrefereencesJson =
        sharedPreferences.getString(CACHED_USER_PREFERENCES);
    if (userPrefereencesJson == null) {
      return throw Exception('No cached user preferences');
    }
    return Future.value(
        UserPreferencesModel.fromJson(json.decode(userPrefereencesJson)));
  }

  @override
  Future<void> CacheUserPreferences(UserPreferencesModel userPrefereencesJson) {
    sharedPreferences.setString(
        CACHED_USER_PREFERENCES, json.encode(userPrefereencesJson.toJson()));
    return Future.value(Void);
  }
}
