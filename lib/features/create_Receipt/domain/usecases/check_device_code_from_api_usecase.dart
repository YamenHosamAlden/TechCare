import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/repositories/load_resources_repository.dart';

class CheckDeviceCodeFromApiUsecase extends Usecase<bool, String> {
  final LoadResourcesRepository loadResourcesRepository;

  CheckDeviceCodeFromApiUsecase({required this.loadResourcesRepository});
  @override
  Future<Either<Failure, bool>> call(String deviceCode)  =>
       loadResourcesRepository.checkDeviceCodeFromApi(deviceCode);
}
