import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/user_preferences/domain/repositories/user_preferences_repository.dart';

class ChangeAppLanguageUsecase extends Usecase<void, Params> {
  final UserPreferencesRepository userPreferencesRepository;

  ChangeAppLanguageUsecase(this.userPreferencesRepository);

  @override
  Future<Either<Failure, void>> call(Params params) {
    return userPreferencesRepository.setPreferredLanguage(params.locale);
  }
}

class Params {
  final Locale locale;
  Params({required this.locale});
}
