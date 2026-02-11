import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/app_launch/domain/entity/version_status.dart';

abstract class AppLaunchRepository {
  Future<Either<Failure, VersionStatus>> getAppStatus();
}
