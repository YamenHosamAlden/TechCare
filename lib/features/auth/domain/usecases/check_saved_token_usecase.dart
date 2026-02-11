import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/auth/domain/repositories/auth_repository.dart';

class CheckSaveTokenUseCase extends Usecase<void, NoParams> {
  final AuthRepository repository;
  CheckSaveTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.validateSavedToken();
  }
}
