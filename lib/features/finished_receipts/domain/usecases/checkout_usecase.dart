import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/checkout_form_data.dart';
import 'package:tech_care_app/features/finished_receipts/domain/repositories/finished_receipts_repository.dart';

class CheckoutUsecase extends Usecase<void, CheckoutParams> {
  final FinishedReceiptsRepository repository;

  CheckoutUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.checkout(
      params.containerId,
      params.checkoutFormData,
 
    );
  }
}

class CheckoutParams {
  final int containerId;
  final CheckoutFormData checkoutFormData;
  

  CheckoutParams({
    required this.containerId,
    required this.checkoutFormData,

  });
}
