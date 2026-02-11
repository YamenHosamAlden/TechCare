import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/quality_report_feed.dart';
import 'package:tech_care_app/features/quality_report/domain/repository/quality_report_repository.dart';

class LoadQualityReportFeedUsecase extends Usecase<QualityReportFeed, int> {
  final QualityReportRepository repository;

  LoadQualityReportFeedUsecase({required this.repository});

  @override
  Future<Either<Failure, QualityReportFeed>> call(int deviceId) async {
    return repository.getFeed(deviceId);
  }
}
