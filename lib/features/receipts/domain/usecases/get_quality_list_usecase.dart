import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipts/domain/entities/receipt.dart';
import 'package:tech_care_app/features/receipts/domain/repositories/receipts_repository.dart';

class GetQualityListUsecase extends Usecase<List<Receipt>, void> {
  final ReceiptsRepository receiptsRepository;
  GetQualityListUsecase({required this.receiptsRepository});

  @override
  Future<Either<Failure, List<Receipt>>> call(Void) {
       return receiptsRepository.getQualityList();

  }
}
