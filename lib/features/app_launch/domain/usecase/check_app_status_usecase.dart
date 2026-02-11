import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/app_launch/domain/entity/version_status.dart';
import 'package:tech_care_app/features/app_launch/domain/repository/app_launch_repository.dart';

class CheckAppStatusUsecase extends Usecase<VersionStatus, NoParams> {
  final AppLaunchRepository repository;

  CheckAppStatusUsecase({required this.repository});
  @override
  Future<Either<Failure, VersionStatus>> call(NoParams params) {
    return repository.getAppStatus();
  }
}
