import 'package:dartz/dartz.dart';

import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/container_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/repositories/container_details_repository.dart';

class EditReceiptDetailsUsecase extends Usecase<void, ContainerDetailsParams> {
  ContainerDetailsRepository containerDetailsRepository;
  EditReceiptDetailsUsecase({
    required this.containerDetailsRepository,
  });
  @override
  Future<Either<Failure, void>> call(
          ContainerDetailsParams containerDetailsParams) =>
      containerDetailsRepository
          .editReceiptDetails(containerDetailsParams.containerDetails,
              containerDetailsParams.onSendProgress)
          .then((value) => value.fold((failure) => Left(failure), (v) {
                containerDetailsRepository
                    .editReceiptFromReceiptContainerDetails(
                        containerDetailsParams.containerDetails);
                return Right(v);
              }));
}

class ContainerDetailsParams {
  final ContainerDetails containerDetails;
  final void Function(int, int)? onSendProgress;

  ContainerDetailsParams({required this.containerDetails, this.onSendProgress});
}
