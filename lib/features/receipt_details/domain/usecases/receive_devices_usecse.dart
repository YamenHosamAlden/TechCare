import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipt_details/domain/repositories/receipt_details_repository.dart';
import 'package:tech_care_app/features/receipts/domain/repositories/receipts_repository.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';

class ReceiveDevicesUsecase extends Usecase<void, ReceiveDevicesParam> {
  final ReceiptDetailsRepostiory receiptDetailsRepostiory;
  final ReceiptsRepository receiptsRepository;

  ReceiveDevicesUsecase(
      {required this.receiptsRepository,
      required this.receiptDetailsRepostiory});

  @override
  Future<Either<Failure, void>> call(ReceiveDevicesParam params) async {
    return receiptDetailsRepostiory
        .receiveDevices(params.deviceCodes)
        .then((value) => value.fold((failure) => Left(failure), (newReceipt) {
              return receiptsRepository.addToReceivedList(
                  receiptDisplayType: params.receiptDisplayType,
                  newReceipt: newReceipt);
            }));
  }
}

final class ReceiveDevicesParam {
  final List<String> deviceCodes;
  ReceiptDisplayType receiptDisplayType;
  ReceiveDevicesParam(
      {required this.deviceCodes, required this.receiptDisplayType});
}
