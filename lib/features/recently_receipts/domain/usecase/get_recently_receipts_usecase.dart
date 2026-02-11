import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/recently_receipts/domain/repository/recently_receipts_repository.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';

class GetRecentlyReceiptsUsecase
    extends Usecase<List<ReceiptContainer>, void> {
  RecentlyReceiptsRepository recentlyReceiptsRepository;
  GetRecentlyReceiptsUsecase({required this.recentlyReceiptsRepository});

  @override
  Future<Either<Failure, List<ReceiptContainer>>> call(params) {
    return recentlyReceiptsRepository.getRecentlyAddedReceipts();
  }
}
