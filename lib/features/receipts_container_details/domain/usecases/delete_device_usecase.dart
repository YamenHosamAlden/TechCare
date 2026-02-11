import 'package:dartz/dartz.dart';

import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipt_details/domain/repositories/receipt_details_repository.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/repositories/container_details_repository.dart';

class DeleteDeviceUsecase extends Usecase<void, int> {
  ContainerDetailsRepository containerDetailsRepository;
  ReceiptDetailsRepostiory receiptDetailsRepostiory;
  DeleteDeviceUsecase(
      {required this.containerDetailsRepository,
      required this.receiptDetailsRepostiory});
  @override
  Future<Either<Failure, void>> call(deviceId) {
    return containerDetailsRepository
        .deleteDevice(deviceId)
        .then((value) => value.fold((l) => Left(l), (v) {
              receiptDetailsRepostiory.removeDeviceFromReceiptDetails(deviceId);
              return Right(v);
            }));
  }
}
