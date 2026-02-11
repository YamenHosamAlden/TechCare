import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';
import 'package:tech_care_app/features/saerch/domain/repository/search_repository.dart';

class SearchByReceiptUsecase extends Usecase<List<ReceiptContainer>, String> {
  final SearchRepository repository;
  SearchByReceiptUsecase({required this.repository});

  @override
  Future<Either<Failure, List<ReceiptContainer>>> call(String term) {
    return repository.searchByReceipt(term);
  }
}
