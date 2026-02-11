import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/maintenance_group.dart';
import 'package:tech_care_app/features/create_receipt/domain/repositories/create_receipt_repository.dart';

class LoadCreateReceiptResUsecase extends Usecase<void, NoParams> {
  final CreateReceiptRepository createReceiptRepository;

  LoadCreateReceiptResUsecase(this.createReceiptRepository);

  @override
  Future<Either<Failure, List<MaintenanceGroup>>> call(NoParams params) {
    return createReceiptRepository.loadResources();
  }
}
