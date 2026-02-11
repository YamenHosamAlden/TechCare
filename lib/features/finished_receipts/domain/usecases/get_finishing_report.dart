import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/finishing_report.dart';
import 'package:tech_care_app/features/finished_receipts/domain/repositories/finished_receipts_repository.dart';

class GetFinishingReportUsecase extends Usecase<FinishingReport, int> {
  final FinishedReceiptsRepository repository;

  GetFinishingReportUsecase({required this.repository});

  @override
  Future<Either<Failure, FinishingReport>> call(containerId) {
    return repository.getFinishingReport(containerId);
  }
}
