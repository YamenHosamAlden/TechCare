import 'dart:ffi';
import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/device_details/domain/repositories/device_details_repository.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/maintenance_report.dart';
import 'package:tech_care_app/features/maintenance_report/domain/repositories/maintenance_report_repository.dart';

class SubmitMReportUsecase extends Usecase<void, ReportParams> {
  final MaintenanceReportRepository maintenanceReportRepository;
  final DeviceDetailsRepository deviceDetailsRepository;
  SubmitMReportUsecase({
    required this.maintenanceReportRepository,
    required this.deviceDetailsRepository,
  });

  @override
  Future<Either<Failure, void>> call(ReportParams params) async {
    Failure? failure;

    await maintenanceReportRepository
        .createReport(params.deviceId, params.maintenanceReport)
        .then((value) => value.fold((_failure) {
              failure = _failure;
            }, (report) {
              failure = null;
              deviceDetailsRepository.addReport(report);
            }));
    if (failure != null) {
      return Left(failure!);
    }
    return (Right(Void));
  }
}

class ReportParams {
  final int deviceId;
  final MaintenanceReport maintenanceReport;

  ReportParams({
    required this.deviceId,
    required this.maintenanceReport,
  });
}
