import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/device_details/domain/repositories/device_details_repository.dart';

class StartTimerUsecase extends Usecase<void, StartTimerParams> {
  final DeviceDetailsRepository deviceDetailsRepository;

  StartTimerUsecase({required this.deviceDetailsRepository});

  @override
  Future<Either<Failure, void>> call(StartTimerParams params) {
    return deviceDetailsRepository.startTimer(params.deviceID);
  }
}

class StartTimerParams {
  final int deviceID;
  StartTimerParams({required this.deviceID});
}
