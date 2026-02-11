import 'package:dartz/dartz.dart';

import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipt_details/domain/repositories/receipt_details_repository.dart';
import 'package:tech_care_app/features/receipt_details/presentation/bloc/receipt_details_bloc.dart';

class StreamReceiptsDetailsEventUsecae
    extends Usecase<Stream<ReceiptDetailsEvent>, void> {
  ReceiptDetailsRepostiory receiptDetailsRepostiory;
  StreamReceiptsDetailsEventUsecae({
    required this.receiptDetailsRepostiory,
  });
  @override
  Future<Either<Failure, Stream<ReceiptDetailsEvent>>> call(params) {
    return receiptDetailsRepostiory.receiptDetailsStream;
  }
}
