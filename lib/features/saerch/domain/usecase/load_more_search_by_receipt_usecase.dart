import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';
import 'package:tech_care_app/features/saerch/domain/repository/search_repository.dart';

class LoadMoreSearchByReceiptUsecase
    extends Usecase<List<ReceiptContainer>, SearchByReceiptParams> {
  final SearchRepository repository;
  LoadMoreSearchByReceiptUsecase({required this.repository});

  @override
  Future<Either<Failure, List<ReceiptContainer>>> call(
      SearchByReceiptParams searchByReceiptParams) {
    return repository.loadMoreSearchByReceipt(
        searchByReceiptParams.trem, searchByReceiptParams.page);
  }
}

class SearchByReceiptParams {
  final int page;
  final String trem;
  SearchByReceiptParams({
    required this.page,
    required this.trem,
  });
}
