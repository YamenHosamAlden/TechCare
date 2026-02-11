import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> get getUser;
  void removeUser();
  
}
