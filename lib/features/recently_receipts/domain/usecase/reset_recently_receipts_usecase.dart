import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/recently_receipts/domain/repository/recently_receipts_repository.dart';

class ResetRecentlyReceiptsUsecase extends Usecase<void, void> {
  final RecentlyReceiptsRepository recentlyReceiptsRepository;
  ResetRecentlyReceiptsUsecase({required this.recentlyReceiptsRepository});

  @override
  Future<Either<Failure, void>> call(Void) async {
    recentlyReceiptsRepository.resetRecentlyReceipts();
    return Right(Void);
  }
}
