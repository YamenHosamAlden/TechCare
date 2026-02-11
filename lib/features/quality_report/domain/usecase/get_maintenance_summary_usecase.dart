import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/maintenance_summary.dart';
import 'package:tech_care_app/features/quality_report/domain/repository/quality_report_repository.dart';

class GetMaintenanceSummaryUsecase extends Usecase<MaintenanceSummary, int> {
  final QualityReportRepository repository;

  GetMaintenanceSummaryUsecase({required this.repository});

  @override
  Future<Either<Failure, MaintenanceSummary>> call(int deviceId) async {
    return repository.getMaintenanceSummary(deviceId);
  }
}
