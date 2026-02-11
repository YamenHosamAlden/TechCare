import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/create_receipt/data/models/company_model.dart';
import 'package:tech_care_app/features/create_receipt/data/models/device_type_model.dart';
import 'package:tech_care_app/features/create_receipt/data/models/maintenance_group_model.dart';
import 'package:tech_care_app/features/create_receipt/data/models/new_receipt_model.dart';

abstract class CreateReceiptRemoteDateSource {
  Future<String> createReceipt(NewRerceiptModel newRerceiptModel,
      {void Function(int, int)? onSendProgress});
  Future<List<CompanyModel>> getCompanies();
  Future<List<DeviceTypeModel>> getDeviceTypes();
  Future<List<MaintenanceGroupModel>> getMaintenanceGroups();
  Future<bool> checkDeviceCode(String code);
}

class CreateReceiptRemoteDateSourceImpl
    implements CreateReceiptRemoteDateSource {
  final Dio dio;

  CreateReceiptRemoteDateSourceImpl({required this.dio});

  String get baseUrl => ServerConfig().maintenanceServerAddress;
  String get baseUrl2 => ServerConfig().authServerAddress;

  @override
  Future<List<CompanyModel>> getCompanies() async {
    final res = await dio.get(baseUrl + 'companies/all');
    if (res.statusCode == 200) {
      return (res.data['data'] as List)
          .map<CompanyModel>(
              (companyJson) => CompanyModel.fromJson(companyJson))
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<List<DeviceTypeModel>> getDeviceTypes() async {
    final res = await dio.get(baseUrl + 'types/all');
    if (res.statusCode == 200) {
      return (res.data['data'] as List)
          .map<DeviceTypeModel>(
              (typeJson) => DeviceTypeModel.fromJson(typeJson))
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<List<MaintenanceGroupModel>> getMaintenanceGroups() async {
    final res = await dio.get(baseUrl2 + 'getGroups');

    if (res.statusCode == 200 && res.data['success'] == true) {
      return (res.data['data'] as List)
          .map((groupJson) => MaintenanceGroupModel.fromJson(groupJson))
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<String> createReceipt(NewRerceiptModel newRerceiptModel,
      {void Function(int, int)? onSendProgress}) async {
    FormData form = FormData.fromMap(newRerceiptModel.toJson());
    final res = await dio.post(
      baseUrl + 'receipt',
      data: form,
      onSendProgress: onSendProgress,
    );
    // print(res.data);
    if (res.statusCode == 200) {
      return res.data['data'];
    }
    throw Exception();
  }

  @override
  Future<bool> checkDeviceCode(String code) async {
 

    final res = await dio.get(baseUrl + 'checkCode/$code');
    if (res.statusCode == 200) {
      bool result = res.data['success'];
      return result;
    }
    throw ServerException();
  }
}
