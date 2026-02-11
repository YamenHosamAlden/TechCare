import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/user_preferences/domain/entities/user_preferences.dart';

abstract class UserPreferencesRepository {
  Future<Either<Failure, UserPreferences>> getUserPreference();
  Future<Either<Failure, void>> setUserPreferences(
      UserPreferences userPreferences);
      
  Future<Either<Failure, Locale>> getPreferredLanguage();
  Future<Either<Failure, void>> setPreferredLanguage(Locale locale);
}
