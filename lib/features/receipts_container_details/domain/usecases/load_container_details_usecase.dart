import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/container_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/repositories/container_details_repository.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/receipts_container_details_page.dart';

class LoadContainerDetailsUsecase extends Usecase<ContainerDetails, Params> {
  final ContainerDetailsRepository repository;

  LoadContainerDetailsUsecase({required this.repository});

  @override
  Future<Either<Failure, ContainerDetails>> call(Params params) {
    return repository.getContainerDetails(
        params.containerId, params.displayType);
  }
}

final class Params {
  final int containerId;
  final ContainerDisplayType displayType;

  Params({required this.containerId, required this.displayType});
}
