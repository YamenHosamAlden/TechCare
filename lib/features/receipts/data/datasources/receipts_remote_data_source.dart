import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/receipts/data/models/receipts_model.dart';

abstract class ReceiptsRemoteDataSource {
  Future<List<ReceiptModel>> getReceivedList(int page);
  Future<List<ReceiptModel>> getMaintenanceList(int page);
  Future<List<ReceiptModel>> getQualityList(int page);
}

class ReceiptsRemoteDataSourceImpl implements ReceiptsRemoteDataSource {
  final Dio dio;
  ReceiptsRemoteDataSourceImpl({required this.dio}){}

  get baseUrl => ServerConfig().maintenanceServerAddress;

  @override
  Future<List<ReceiptModel>> getReceivedList(int page) async {
    final Response response =
        await dio.get(baseUrl + 'received', queryParameters: {'page': page});
    if (response.statusCode == 200) {
      return (response.data['data'] as List)
          .map((json) => ReceiptModel.fromJson(json))
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<List<ReceiptModel>> getMaintenanceList(int page) async {
    final Response response =
        await dio.get(baseUrl + 'maintenance', queryParameters: {'page': page});
    // print(response.statusCode);
    // print(response.data);

    if (response.statusCode == 200) {
      return (response.data['data'] as List)
          .map((json) => ReceiptModel.fromJson(json))
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<List<ReceiptModel>> getQualityList(int page) async {
    final Response response =
        await dio.get(baseUrl + 'quality', queryParameters: {'page': page});
    if (response.statusCode == 200) {
      return (response.data['data'] as List)
          .map((json) => ReceiptModel.fromJson(json))
          .toList();
    }
    throw ServerException();
  }
}
