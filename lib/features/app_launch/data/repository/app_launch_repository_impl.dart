import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/app_launch/data/datasource/app_launch_remote_data_source.dart';
import 'package:tech_care_app/features/app_launch/domain/entity/version_status.dart';
import 'package:tech_care_app/features/app_launch/domain/repository/app_launch_repository.dart';

class AppLaunchRepositoryImpl extends AppLaunchRepository {
  final AppLaunchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AppLaunchRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, VersionStatus>> getAppStatus() async {
    if (await networkInfo.isConnected) {
      try {
        final VersionStatus appStatus = await remoteDataSource.getAppStatus();
        return Right(appStatus);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    }
    return Left(InternetConnectionFailure());
  }
}
