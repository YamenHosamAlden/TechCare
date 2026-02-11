import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/quality_report/data/data_source/quality_report_remote_data_source.dart';
import 'package:tech_care_app/features/quality_report/data/model/external_item_model.dart';
import 'package:tech_care_app/features/quality_report/data/model/quality_report_model.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/external_item.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/maintenance_summary.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/quality_report.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/quality_report_feed.dart';
import 'package:tech_care_app/features/quality_report/domain/repository/quality_report_repository.dart';

class QualityReportRepositoryImpl implements QualityReportRepository {
  final QualityReportRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  QualityReportRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  int? savedDeviceId;
  QualityReportFeed? savedFeed;

  @override
  Future<Either<Failure, QualityReportFeed>> getFeed(int deviceId) async {
    // if (deviceId == savedDeviceId && savedFeed != null) {
    //   return Right(savedFeed!);
    // } else
    if (await networkInfo.isConnected) {
      savedDeviceId = deviceId;
      try {
        final feed = await remoteDataSource.getFeed(deviceId);
        savedFeed = feed;
        return Right(savedFeed!);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } catch (e) {
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ProcessReport>> createReport(
      int deviceId, QualityReport qualityReport) async {
    if (await networkInfo.isConnected) {
      try {
        final ProcessReport report = await remoteDataSource.createReport(
            deviceId, QualityReportModel.fromEntity(qualityReport));
        reset();
        return Right(report.copyWith(isRecentlyAdded: true));
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  void reset() {
    savedFeed = null;
    savedDeviceId = null;
  }

  @override
  Future<Either<Failure, void>> submitPricedItems(
      int deviceId, List<ExternalItem> items) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.submitPricedItems(deviceId,
            items.map((e) => ExternalItemModel.fromEntity(e)).toList());
        reset();
        return Right(null);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } catch (e) {
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, MaintenanceSummary>> getMaintenanceSummary(
      int deviceId) async {
    if (await networkInfo.isConnected) {
      try {
        final MaintenanceSummary maintenanceSummary =
            await remoteDataSource.getMaintenanceSummary(deviceId);

        return Right(maintenanceSummary);
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }
}
