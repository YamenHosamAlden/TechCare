import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase extends Usecase<void, Params> {
  final AuthRepository repository;
  LoginUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.login(params.userName, params.passWord);
  }
}

class Params extends Equatable {
  final String userName;
  final String passWord;
  Params({required this.userName, required this.passWord});

  @override
  List<Object?> get props => [this.userName, this.passWord];
}
