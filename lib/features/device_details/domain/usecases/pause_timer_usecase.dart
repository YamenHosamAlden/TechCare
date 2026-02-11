import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/device_details/domain/repositories/device_details_repository.dart';

class PauseTimerUsecase extends Usecase<void, PauseTimerParams> {
  final DeviceDetailsRepository deviceDetailsRepository;

  PauseTimerUsecase({required this.deviceDetailsRepository});

  @override
  Future<Either<Failure, void>> call(PauseTimerParams params) {
    return deviceDetailsRepository.pauseTimer(params.deviceID);
  }
}

class PauseTimerParams {
  final int deviceID;
  PauseTimerParams({required this.deviceID});
}
