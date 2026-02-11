import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/receipt_details.dart';
import 'package:tech_care_app/features/receipt_details/domain/repositories/receipt_details_repository.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';

class GetReceiptDetailsByDeviceCodeUsecase
    extends Usecase<ReceiptDetails, ByDeviceCodeParams> {
  final ReceiptDetailsRepostiory receiptDetailsRepostiory;

  GetReceiptDetailsByDeviceCodeUsecase(
      {required this.receiptDetailsRepostiory});

  @override
  Future<Either<Failure, ReceiptDetails>> call(ByDeviceCodeParams params) {
    return receiptDetailsRepostiory.getReceiptDetailsByDeviceCode(
        params.deviceCode, params.receiptDisplayType);
  }
}

class ByDeviceCodeParams {
  final String deviceCode;
  final ReceiptDisplayType receiptDisplayType;
  ByDeviceCodeParams({
    required this.deviceCode,
    required this.receiptDisplayType,
  });
}
