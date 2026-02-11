import 'package:dartz/dartz.dart';

import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/repositories/container_details_repository.dart';

class DeleteReceiptUsecase extends Usecase<void, int> {
  ContainerDetailsRepository containerDetailsRepository;
  DeleteReceiptUsecase({
    required this.containerDetailsRepository,
  });
  @override
  Future<Either<Failure, void>> call(int params) =>
      containerDetailsRepository.deleteReceipt(params);
}
