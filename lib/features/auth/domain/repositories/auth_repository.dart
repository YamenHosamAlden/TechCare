import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated;
}

abstract class AuthRepository  {
  Future<Either<Failure, Stream<AuthenticationStatus>>> get status;
  Future<Either<Failure, void>> login(String userName, String passWord);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> validateSavedToken();
}
