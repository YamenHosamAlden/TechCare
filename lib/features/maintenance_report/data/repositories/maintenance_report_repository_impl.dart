import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/maintenance_report/data/datasources/maintenance_report_remote_data_sourece.dart';
import 'package:tech_care_app/features/maintenance_report/data/models/maintenance_report_model.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/maintenance_report.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/warehouse_item.dart';
import 'package:tech_care_app/features/maintenance_report/domain/repositories/maintenance_report_repository.dart';

class MaintenanceReportRepositoryImpl implements MaintenanceReportRepository {
  final MaintenanceReportRemoteDataSource remoteDataSource;

  MaintenanceReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WarehouseItem>>> getSuggestedItems(int deviceId,
      String pattern) async {
    return Right(await remoteDataSource.getSuggestedItems(deviceId,pattern));
  }

  @override
  Future<Either<Failure, ProcessReport>> createReport(
      int deviceId, MaintenanceReport maintenanceReport) async {
    try {
      final ProcessReport report = await remoteDataSource.createReport(
          deviceId, MaintenanceReportModel.fromEntity(maintenanceReport));
      return Right(report.copyWith(isRecentlyAdded: true));
    } on DioException catch (error) {
        return Left(DioFailure(error: error));
      }
    catch (e) {
      // print(e);
      return Left(UnknownFailure());
    }
  }
}
