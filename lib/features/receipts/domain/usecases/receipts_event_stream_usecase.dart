// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipts/domain/repositories/receipts_repository.dart';
import 'package:tech_care_app/features/receipts/presentation/bloc/receipts_bloc.dart';

class ReceiptsEventStreamUsecase extends Usecase<Stream<ReceiptsEvent>, void> {
  ReceiptsRepository repository;
  ReceiptsEventStreamUsecase({
    required this.repository,
  });
  @override
  Future<Either<Failure, Stream<ReceiptsEvent>>> call(params) {
    return repository.receiptsEventStream;
  }
}
