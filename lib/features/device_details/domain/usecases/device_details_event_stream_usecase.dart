import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/device_details/domain/repositories/device_details_repository.dart';
import 'package:tech_care_app/features/device_details/presentation/bloc/device_details_bloc/device_details_bloc.dart';

class DeviceDetailsEventStreamUsecase
    extends Usecase<Stream<DeviceDetailsEvent>, void> {
  final DeviceDetailsRepository deviceDetailsRepository;
  DeviceDetailsEventStreamUsecase({required this.deviceDetailsRepository});

  @override
  Future<Either<Failure, Stream<DeviceDetailsEvent>>> call(Void) async {
    return await deviceDetailsRepository.eventStream;
  }
}
