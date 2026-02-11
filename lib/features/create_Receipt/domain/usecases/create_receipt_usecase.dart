import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/collection.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/new_receipt.dart';
import 'package:tech_care_app/features/create_receipt/domain/repositories/create_receipt_repository.dart';

class CreateReceiptUsecase extends Usecase<void, Params> {
  final CreateReceiptRepository createReceiptRepository;

  CreateReceiptUsecase(this.createReceiptRepository);

  @override
  Future<Either<Failure, String>> call(Params params) {
    return createReceiptRepository.createReceipt(
      NewReceipt(
          customerName: params.customerName,
          customerPhone: params.customerPhone,
          priority: params.priority,
          shippingNumber: params.shippingNumber,
          collections: params.collections),
      onSendProgress: params.onSendProgress,
    );
  }
}

class Params {
  final String customerName;
  final String customerPhone;
  final TranslatableValue priority;
  final String? shippingNumber;
  final List<Collection> collections;
  final void Function(int, int)? onSendProgress;

  Params(
      {required this.customerName,
      required this.customerPhone,
      required this.priority,
      required this.shippingNumber,
      required this.collections,
      this.onSendProgress});
}
