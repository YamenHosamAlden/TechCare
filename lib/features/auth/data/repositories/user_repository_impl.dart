import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:tech_care_app/features/auth/domain/entities/user.dart';
import 'package:tech_care_app/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final NetworkInfo networkInfo;
  final UserRemoteDataSource remoteDataSource;

  User? user;

  UserRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> get getUser async {
    if (user == null) {
      if (await networkInfo.isConnected) {
        try {
          user = await remoteDataSource.user;
        } on DioException catch (error) {
          return Left(DioFailure(error: error));
        } on ServerException {
          return Left(ServerFailure());
        } catch (e) {
          print("what is the error $e");
          return Left((UnknownFailure()));
        }
      } else {
        return Left(InternetConnectionFailure());
      }
    }
    return Right(user!);
  }

  @override
  void removeUser() {
    user = null;
  }
}
