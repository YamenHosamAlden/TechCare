import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/user_preferences/domain/entities/user_preferences.dart';
import 'package:tech_care_app/features/user_preferences/domain/repositories/user_preferences_repository.dart';

class GetUserPreferenceUsecase extends Usecase<UserPreferences, void> {
  final UserPreferencesRepository userPreferencesRepository;

  GetUserPreferenceUsecase(this.userPreferencesRepository);

  @override
  Future<Either<Failure, UserPreferences>> call(Void) {
    return userPreferencesRepository.getUserPreference();
  }
}
