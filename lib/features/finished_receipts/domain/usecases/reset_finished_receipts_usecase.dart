import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/repositories/finished_receipts_repository.dart';

class ResetFinishedReceiptsUsecase extends Usecase<void, void> {
  final FinishedReceiptsRepository finishedReceiptsRepository;
  ResetFinishedReceiptsUsecase({required this.finishedReceiptsRepository});

  @override
  Future<Either<Failure, void>> call(Void) async {
    finishedReceiptsRepository.resetFinishedReceipts();
    return Right(Void);
  }
}
