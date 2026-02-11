import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/device_details/domain/entities/device_details.dart';
import 'package:tech_care_app/features/device_details/domain/repositories/device_details_repository.dart';

class GetDeviceDetailsUsecase extends Usecase<DeviceDetails, Params> {
  final DeviceDetailsRepository deviceDetailsRepository;

  GetDeviceDetailsUsecase({required this.deviceDetailsRepository});

  @override
  Future<Either<Failure, DeviceDetails>> call(Params params) {
    if (params.deviceCode != null) {
      return deviceDetailsRepository.GetDeviceDetailsByCode(params.deviceCode!);
    }
    return deviceDetailsRepository.GetDeviceDetailsById(params.deviceID!);
  }
}

class Params {
  final int? deviceID;
  final String? deviceCode;
  Params({required this.deviceID, required this.deviceCode});
}
