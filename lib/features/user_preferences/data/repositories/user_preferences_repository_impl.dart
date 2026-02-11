import 'dart:ffi';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/user_preferences/data/datasources/user_preferences_local_data_source.dart';
import 'package:tech_care_app/features/user_preferences/data/models/user_preferences_model.dart';
import 'package:tech_care_app/features/user_preferences/domain/entities/user_preferences.dart';
import 'package:tech_care_app/features/user_preferences/domain/repositories/user_preferences_repository.dart';

class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  final UserPreferencesLocalDataSource localDataSource;

  UserPreferencesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserPreferences>> getUserPreference() async {
    try {
      final UserPreferences userPreferencesModel =
          await localDataSource.getCachedUserPreferences();
      return Right(userPreferencesModel);
    } on CacheException {
    } catch (exception) {}
    return Right(UserPreferences(locale: Locale('en')));
  }

  @override
  Future<Either<Failure, void>> setUserPreferences(
      UserPreferences userPreferences) async {
    try {
      await localDataSource.CacheUserPreferences(
          UserPreferencesModel.fromEntity(userPreferences));
    } catch (exception) {}
    return Right(Void);
  }

  @override
  Future<Either<Failure, Locale>> getPreferredLanguage() async {
    try {
      final UserPreferencesModel userPreferencesModel =
          await localDataSource.getCachedUserPreferences();
      return Right(userPreferencesModel.locale);
    } catch (exception) {}
    return Right(Locale('en'));
  }

  @override
  Future<Either<Failure, void>> setPreferredLanguage(Locale locale) async {
    try {
      this
          .getUserPreference()
          .then((value) => value.fold((l) => null, (userPreferences) {
                // All attributes in userPreferencesModel must be passed to NewUserPreferencesModel except the one we want to change.
                final UserPreferencesModel NewUserPreferencesModel =
                    UserPreferencesModel(locale: locale);
                this.setUserPreferences(NewUserPreferencesModel);
              }));
    } catch (exception) {}
    return Right(Void);
  }
}
