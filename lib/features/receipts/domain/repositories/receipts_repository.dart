import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/receipts/domain/entities/receipt.dart';
import 'package:tech_care_app/features/receipts/presentation/bloc/receipts_bloc.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';

abstract class ReceiptsRepository {
  Future<Either<Failure, List<Receipt>>> getReceivedList();
  Future<Either<Failure, List<Receipt>>> getMaintenanceList();
  Future<Either<Failure, List<Receipt>>> getQualityList();

  Future<Either<Failure, List<Receipt>>> reloadReceivedList();
  Future<Either<Failure, List<Receipt>>> reloadMaintenanceList();
  Future<Either<Failure, List<Receipt>>> reloadQualityList();

  Future<Either<Failure, List<Receipt>>> loadMoreReceivedReceipts();
  Future<Either<Failure, List<Receipt>>> loadMoreMaintenanceReceipts();
  Future<Either<Failure, List<Receipt>>> loadMoreQualityReceipts();

  Future<Either<Failure, Stream<ReceiptsEvent>>> get receiptsEventStream;
  Future<Either<Failure, void>> addToReceivedList(
      {Receipt? newReceipt, required ReceiptDisplayType receiptDisplayType});

  void reset();
}
