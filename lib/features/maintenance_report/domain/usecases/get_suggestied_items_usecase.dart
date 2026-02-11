import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/warehouse_item.dart';
import 'package:tech_care_app/features/maintenance_report/domain/repositories/maintenance_report_repository.dart';

class GetSuggestedItemsUsecase extends Usecase<List<WarehouseItem>, Params> {
  final MaintenanceReportRepository maintenanceReportRepository;
  GetSuggestedItemsUsecase({required this.maintenanceReportRepository});

  @override
  Future<Either<Failure, List<WarehouseItem>>> call(Params params) {
    return maintenanceReportRepository.getSuggestedItems(
        params.deviceId, params.pattern);
  }
}

class Params {
  final String pattern;
  final int deviceId;

  Params({required this.deviceId, required this.pattern});
}
