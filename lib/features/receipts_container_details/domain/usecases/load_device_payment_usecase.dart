import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_payment_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/repositories/container_details_repository.dart';

class LoadDevicePaymentDetailsUsecase extends Usecase<DevicePaymentDetails, int> {
  final ContainerDetailsRepository containerDetailsRepository;

  LoadDevicePaymentDetailsUsecase({
    required this.containerDetailsRepository,
  });

  @override
  Future<Either<Failure, DevicePaymentDetails>> call(deviceId) =>
      containerDetailsRepository.getDevicePaymentDetails(deviceId);
}
