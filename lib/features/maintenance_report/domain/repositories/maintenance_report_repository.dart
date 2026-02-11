import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/maintenance_report.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/warehouse_item.dart';

abstract class MaintenanceReportRepository {
  Future<Either<Failure, List<WarehouseItem>>> getSuggestedItems(
      int deviceId, String pattern);

  Future<Either<Failure, ProcessReport>> createReport(
      int deviceId, MaintenanceReport maintenanceReport);
}
