import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/device_details/domain/repositories/device_details_repository.dart';

class UnreceiveDeviceUsecase extends Usecase<ProcessReport, UnreceiveDeviceParams> {
  final DeviceDetailsRepository deviceDetailsRepository;

  UnreceiveDeviceUsecase({required this.deviceDetailsRepository});

  @override
  Future<Either<Failure, ProcessReport>> call(UnreceiveDeviceParams params) {
  
    return deviceDetailsRepository.unreceiveDevice(
        params.deviceID, params.reason);
  }
}

class UnreceiveDeviceParams {
  final int deviceID;
  final String reason;

  UnreceiveDeviceParams({
    required this.deviceID,
    required this.reason,
  });
}
