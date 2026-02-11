import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/repositories/load_resources_repository.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_resoucres.dart';

class LoadDeviceResUsecase extends Usecase<DeviceResources, NoParams> {
  final LoadResourcesRepository loadResourcesRepository;

  LoadDeviceResUsecase({required this.loadResourcesRepository});

  @override
  Future<Either<Failure, DeviceResources>> call(NoParams params) {
    return loadResourcesRepository.loadResources();
  }
}
