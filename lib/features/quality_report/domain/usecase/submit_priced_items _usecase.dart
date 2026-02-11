import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/external_item.dart';
import 'package:tech_care_app/features/quality_report/domain/repository/quality_report_repository.dart';

class SubmitPricedItemsUsecase extends Usecase<void, SubmitPricedItemsParams> {
  final QualityReportRepository qualityReportRepository;

  SubmitPricedItemsUsecase({
    required this.qualityReportRepository,
  });

  @override
  Future<Either<Failure, void>> call(SubmitPricedItemsParams params) {
    return qualityReportRepository.submitPricedItems(
        params.deviceId, params.pricedItems);
  }
}

class SubmitPricedItemsParams {
  final int deviceId;
  final List<ExternalItem> pricedItems;

  SubmitPricedItemsParams({
    required this.deviceId,
    required this.pricedItems,
  });
}
