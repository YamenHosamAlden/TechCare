import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/receipt_details.dart';
import 'package:tech_care_app/features/receipt_details/domain/repositories/receipt_details_repository.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';

class GetReceiptDetailsByReceiptIdUsecase
    extends Usecase<ReceiptDetails, Params> {
  final ReceiptDetailsRepostiory receiptDetailsRepostiory;

  GetReceiptDetailsByReceiptIdUsecase({required this.receiptDetailsRepostiory});

  @override
  Future<Either<Failure, ReceiptDetails>> call(Params params) {
    return receiptDetailsRepostiory.getReceiptDetailsByReceiptId(
        params.receiptID, params.receiptDisplayType);
  }
}

final class Params {
  final int receiptID;
  final ReceiptDisplayType receiptDisplayType;
  Params({required this.receiptID, required this.receiptDisplayType});
}
