import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/auth/domain/repositories/auth_repository.dart';

class AuthStatusStreamUsecase extends Usecase<Stream<AuthenticationStatus>, void> {
  final AuthRepository repository;
  AuthStatusStreamUsecase(this.repository);

  @override
  Future<Either<Failure, Stream<AuthenticationStatus>>> call(Void) async {
    return await repository.status;
  }
}