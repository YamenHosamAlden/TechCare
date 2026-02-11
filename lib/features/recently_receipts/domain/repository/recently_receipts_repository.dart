import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';

abstract class RecentlyReceiptsRepository {
  Future<Either<Failure, List<ReceiptContainer>>> getRecentlyAddedReceipts();
  Future<Either<Failure, List<ReceiptContainer>>> reloadRecentlyAddedReceipts();
  Future<Either<Failure, List<ReceiptContainer>>>
      loadMoreRecentlyAddedReceipts();
  void resetRecentlyReceipts();
}
