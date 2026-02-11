import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/receipt_details.dart';
import 'package:tech_care_app/features/receipt_details/presentation/bloc/receipt_details_bloc.dart';
import 'package:tech_care_app/features/receipts/domain/entities/receipt.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';

abstract interface class ReceiptDetailsRepostiory {
  Future<Either<Failure, ReceiptDetails>> getReceiptDetailsByReceiptId(
      int receiptID, ReceiptDisplayType receiptDisplayType);
  Future<Either<Failure, ReceiptDetails>> getReceiptDetailsByDeviceCode(
      String deviceCode, ReceiptDisplayType receiptDisplayType);
  Future<Either<Failure, Receipt>> receiveDevices(List<String> devicesCodes);

  Future<Either<Failure, Stream<ReceiptDetailsEvent>>> get receiptDetailsStream;
  void removeDeviceFromReceiptDetails(int deviceId);
  void editDeviceFromReceiptDetails(int deviceId,DeviceInfo deviceInfo);
   
}
