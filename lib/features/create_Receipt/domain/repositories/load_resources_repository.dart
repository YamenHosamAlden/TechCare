import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/collection.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_resoucres.dart';

abstract class LoadResourcesRepository {
  Future<Either<Failure, DeviceResources>> loadResources();
  Future<Either<Failure, bool>> checkDeviceCodeFromCollection(
    String deviceCode,
    List<Collection> collectionList,
    String? codeFromEdit,
  );
  Future<Either<Failure, bool>> checkDeviceCodeFromApi(String deviceCode);
  void reset();
}
