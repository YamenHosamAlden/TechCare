import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/device_details/data/models/process_report_model.dart';
import 'package:tech_care_app/features/quality_report/data/model/external_item_model.dart';
import 'package:tech_care_app/features/quality_report/data/model/maintenance_summary_model.dart';
import 'package:tech_care_app/features/quality_report/data/model/quality_report_feed_model.dart';
import 'package:tech_care_app/features/quality_report/data/model/quality_report_model.dart';

abstract class QualityReportRemoteDataSource {
  Future<QualityReportFeedModel> getFeed(int deviceId);
  Future<MaintenanceSummaryModel> getMaintenanceSummary(int deviceId);

  Future<ProcessReportModel> createReport(
      int deviceId, QualityReportModel qualityReport);

  Future<void> submitPricedItems(int deviceId, List<ExternalItemModel> report);
}

class QualityReportRemoteDataSourceImpl
    implements QualityReportRemoteDataSource {
  final Dio dio;

  String get baseUrl => ServerConfig().maintenanceServerAddress;

  QualityReportRemoteDataSourceImpl({required this.dio});

  @override
  Future<QualityReportFeedModel> getFeed(int deviceId) async {
    final res = await dio.get(baseUrl + 'device/qreportFeed/$deviceId');

    // print(res.statusCode);
    // print(res.data);
    if (res.statusCode == 200 && res.data['success'] == true) {
      return QualityReportFeedModel.fromJson(res.data['data']);
    }
    throw ServerException();
  }

  @override
  Future<ProcessReportModel> createReport(
      int deviceId, QualityReportModel qualityReport) async {
    final Map<String, dynamic> reqData = {'device_id': deviceId};
    reqData.addAll(qualityReport.toJson());
    await Future.delayed(Durations.extralong4);

    final res = await dio.post(baseUrl + 'device/qreport', data: reqData);

    if (res.statusCode == 200) {
      return ProcessReportModel.fromJson(res.data['data']);
    }

    throw ServerException();
  }

  @override
  Future<void> submitPricedItems(
      int deviceId, List<ExternalItemModel> pricedItems) async {
    final Map<String, dynamic> reqData = {
      'device_id': deviceId,
      'externalItems': pricedItems.map((item) => item.toJson()).toList(),
    };

    final res =
        await dio.post(baseUrl + 'device/setItemsPrices', data: reqData);

    if (res.statusCode == 200 && res.data['success'] == true) {
      return;
    }

    // throw ServerException();
  }

  @override
  Future<MaintenanceSummaryModel> getMaintenanceSummary(int deviceId) async {
    final res = await dio.get(baseUrl + 'device/getQReport/$deviceId');

    if (res.statusCode == 200) {
      return MaintenanceSummaryModel.fromJson(res.data);
    }
    throw ServerException();
  }
}
