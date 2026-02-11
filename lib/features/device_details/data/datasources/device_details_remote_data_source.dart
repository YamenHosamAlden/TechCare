import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/device_details/data/models/device_details_model.dart';
import 'package:tech_care_app/features/device_details/data/models/process_report_model.dart';

abstract class DeviceDetailsRemoteDataSource {
  Future<DeviceDetailsModel> DeviceDetailsById(int deviceID);
  Future<DeviceDetailsModel> DeviceDetailsByCode(String devicecode);
  Future<void> puseTimer(int deviceID);
  Future<void> startTimer(int deviceID);
  Future<ProcessReportModel> addNote(int deviceID, String note);
  Future<ProcessReportModel> unreceiveDevice(int deviceID, String reason);
}

class DeviceDetailsRemoteDataSourceImpl
    implements DeviceDetailsRemoteDataSource {
  final Dio dio;

  DeviceDetailsRemoteDataSourceImpl({required this.dio});

  String get baseUrl => ServerConfig().maintenanceServerAddress;

  @override
  Future<DeviceDetailsModel> DeviceDetailsById(int deviceID) async {
    // print('get device details : $deviceID');
    final res = await dio.get(baseUrl + 'receipt/device/$deviceID');
    // print(res.data);
    if (res.statusCode == 200) {
      return DeviceDetailsModel.fromJson(res.data['data']);
    }
    throw ServerException();
  }

  @override
  Future<DeviceDetailsModel> DeviceDetailsByCode(String deviceCode) async {
    // print('get device details : $deviceCode');
    final res = await dio.get(baseUrl + 'receipt/device/$deviceCode',
        queryParameters: {'code': true});
    // print(res.data);
    if (res.statusCode == 200) {
      return DeviceDetailsModel.fromJson(res.data['data']);
    }
    throw ServerException();
  }

  @override
  Future<void> puseTimer(int deviceID) async {
    final res = await dio.get(baseUrl + 'device/pause/${deviceID}');

    if (res.statusCode == 200 && res.data['success'] == true) {
      return;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> startTimer(int deviceID) async {
    final res = await dio.get(baseUrl + 'device/continue/${deviceID}');

    if (res.statusCode == 200 && res.data['success'] == true) {
      return;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProcessReportModel> addNote(int deviceID, String note) async {
    final res = await dio.post(baseUrl + 'device/note', data: {
      'device_id': deviceID,
      'note': note.trim(),
    });

    if (res.statusCode == 200) {
      return ProcessReportModel.fromJson(res.data['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProcessReportModel> unreceiveDevice(
      int deviceID, String reason) async {
    // print('$deviceID $deviceID $deviceID $deviceID $deviceID');

    final res = await dio.post(baseUrl + 'cancel', data: {
      'device_id': deviceID,
      'note': reason.trim(),
    });

    // print(res.statusCode);
    // print(res.data);

    if (res.statusCode == 200) {
      if (res.data['success'] == true) {
        return ProcessReportModel.fromJson(res.data['data']);
      }
    }
    throw ServerException();
  }
}
