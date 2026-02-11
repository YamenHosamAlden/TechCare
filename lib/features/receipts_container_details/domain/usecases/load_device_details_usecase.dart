import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/repositories/container_details_repository.dart';

class LoadDeviceDetailsUsecase extends Usecase<DeviceDetails, int> {
  final ContainerDetailsRepository containerDetailsRepository;

  LoadDeviceDetailsUsecase({
    required this.containerDetailsRepository,
  });

  @override
  Future<Either<Failure, DeviceDetails>> call(deviceId) {
    return containerDetailsRepository.getDeviceDetailsById(deviceId);
  }
}
