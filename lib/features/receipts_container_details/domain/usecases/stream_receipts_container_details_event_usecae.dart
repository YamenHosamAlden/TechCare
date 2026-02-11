import 'package:dartz/dartz.dart';

import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/repositories/container_details_repository.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/receipts_container_details_bloc/receipts_container_details_bloc.dart';

class StreamReceiptsContainerDetailsEventUsecae
    extends Usecase<Stream<ReceiptsContainerDetailsEvent>, void> {
  ContainerDetailsRepository containerDetailsRepository;
  StreamReceiptsContainerDetailsEventUsecae({
    required this.containerDetailsRepository,
  });
  @override
  Future<Either<Failure, Stream<ReceiptsContainerDetailsEvent>>> call(params) {

    return containerDetailsRepository.receiptsContainerDetailsEventStream;
  }
}
