import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';
import 'package:tech_care_app/features/finished_receipts/domain/repositories/finished_receipts_repository.dart';

class LoadFinishedReceiptsUsecase
    extends Usecase<List<ReceiptContainer>, void> {
  
  final FinishedReceiptsRepository repository;

  LoadFinishedReceiptsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<ReceiptContainer>>> call(Void) {
    return repository.getFinishedReceipts();
  }
}
