import 'package:dartz/dartz.dart';

import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/repositories/load_resources_repository.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/collection.dart';

class CheckDeviceCodeUsecaseFromCollection
    extends Usecase<bool, CheckDeviceCodeParams> {
  final LoadResourcesRepository loadResourcesRepository;
  CheckDeviceCodeUsecaseFromCollection({
    required this.loadResourcesRepository,
  });
  @override
  Future<Either<Failure, bool>> call(
      CheckDeviceCodeParams checkDeviceCodeParams) {
    return loadResourcesRepository.checkDeviceCodeFromCollection(
      checkDeviceCodeParams.deviceCode,
      checkDeviceCodeParams.collectionList,
      checkDeviceCodeParams.codeFromEdit,
    );
  }
}

class CheckDeviceCodeParams {
  final String deviceCode;
  final String? codeFromEdit;
  final List<Collection> collectionList;

  CheckDeviceCodeParams(
      {required this.deviceCode,
      required this.collectionList,
      this.codeFromEdit});
}
