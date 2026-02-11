import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/device_details/domain/repositories/device_details_repository.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/quality_report.dart';
import 'package:tech_care_app/features/quality_report/domain/repository/quality_report_repository.dart';

class SubmitQReportUsecase extends Usecase<void, ReportParams> {
  final QualityReportRepository qualityReportRepository;
  final DeviceDetailsRepository deviceDetailsRepository;
  SubmitQReportUsecase({
    required this.qualityReportRepository,
    required this.deviceDetailsRepository,
  });

  @override
  Future<Either<Failure, void>> call(ReportParams params) async {
    Failure? failure;

    await qualityReportRepository
        .createReport(params.deviceId, params.qualityReport)
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
  final QualityReport qualityReport;

  ReportParams({
    required this.deviceId,
    required this.qualityReport,
  });
}
