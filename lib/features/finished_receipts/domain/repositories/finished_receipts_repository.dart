import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/checkout_form_data.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/finishing_report.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';

abstract class FinishedReceiptsRepository {
  Future<Either<Failure, List<ReceiptContainer>>> getFinishedReceipts();
  Future<Either<Failure, List<ReceiptContainer>>> reloadFinishedReceipts();
  Future<Either<Failure, List<ReceiptContainer>>> loadMoreFinishedReceipts();
  Future<Either<Failure, FinishingReport>> getFinishingReport(int containerId);
  Future<Either<Failure, void>> checkout(
      int containerId, CheckoutFormData checkoutFormData);
  void resetFinishedReceipts();
}
