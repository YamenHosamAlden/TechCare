import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/external_item.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/maintenance_summary.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/quality_report.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/quality_report_feed.dart';

abstract class QualityReportRepository {
  Future<Either<Failure, QualityReportFeed>> getFeed(int deviceId);
  Future<Either<Failure, MaintenanceSummary>> getMaintenanceSummary(
      int deviceId);
  Future<Either<Failure, ProcessReport>> createReport(
      int deviceId, QualityReport report);
  Future<Either<Failure, void>> submitPricedItems(
      int deviceId, List<ExternalItem> report);

  void reset();
}
