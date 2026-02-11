import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/device_details/data/models/process_report_model.dart';
import 'package:tech_care_app/features/maintenance_report/data/models/maintenance_report_model.dart';
import 'package:tech_care_app/features/maintenance_report/data/models/warehouse_item_model.dart';

abstract class MaintenanceReportRemoteDataSource {
  Future<List<WarehouseItemModle>> getSuggestedItems(
      int deviceId, String pattern);
  Future<ProcessReportModel> createReport(
      int deviceId, MaintenanceReportModel maintenanceReport);
}

class MaintenanceReportRemoteDataSourceImpl
    implements MaintenanceReportRemoteDataSource {
  final Dio dio;

  MaintenanceReportRemoteDataSourceImpl({required this.dio});

  String get baseUrl => ServerConfig().maintenanceServerAddress;

  @override
  Future<List<WarehouseItemModle>> getSuggestedItems(
      int deviceId, String pattern) async {
    final res = await dio.get(baseUrl + 'warehouse/search/${pattern.trim()}',
        queryParameters: {'id': deviceId});

    if (res.statusCode == 200) {
      // print(res.data);
      final List<WarehouseItemModle> warehouseItems = (res.data['data'] as List)
          .map((itemJson) => WarehouseItemModle.fromJson(itemJson))
          .toList();

      return warehouseItems;
    }
    throw ServerException();
  }

  @override
  Future<ProcessReportModel> createReport(
      int deviceId, MaintenanceReportModel maintenanceReport) async {
    final Map<String, dynamic> reqData = {'device_id': deviceId};
    reqData.addAll(maintenanceReport.toJson());

    final res = await dio.post(baseUrl + 'device/report', data: reqData);

    if (res.statusCode == 200) {
      // print(res.statusCode);
      // print(res.data);
      return ProcessReportModel.fromJson(res.data['data']);
    }
    throw ServerException();
  }
}
