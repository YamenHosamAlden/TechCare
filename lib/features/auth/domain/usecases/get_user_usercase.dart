import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/auth/domain/entities/user.dart';
import 'package:tech_care_app/features/auth/domain/repositories/user_repository.dart';

class GetUserUsecase extends Usecase<User, void> {
  final UserRepository repository;
  GetUserUsecase(this.repository);

  @override
  Future<Either<Failure, User>> call(Void) async {
    return await repository.getUser;
  }
}
