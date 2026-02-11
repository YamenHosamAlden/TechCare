import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/maintenance_group.dart';

import 'package:tech_care_app/features/create_receipt/domain/entities/new_receipt.dart';

abstract class CreateReceiptRepository {
  Future<Either<Failure, String>> createReceipt(NewReceipt NewReceipt,
      {void Function(int, int)? onSendProgress});
  Future<Either<Failure, List<MaintenanceGroup>>> loadResources();

  void reset();
}
