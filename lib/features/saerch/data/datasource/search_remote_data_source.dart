import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/saerch/data/model/device_info_model.dart';
import 'package:tech_care_app/features/saerch/data/model/receipt_containter_model.dart';
import 'package:tech_care_app/features/saerch/presentation/pages/search_page.dart';

abstract class SearchRemoteDataSource {
  Future<List<ReceiptContainerModel>> searchByReceipt(String term,int page);
  Future<List<DeviceInfoModel>> searchByDevice(String term,int page);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  get baseUrl => ServerConfig().maintenanceServerAddress;

  @override
  Future<List<ReceiptContainerModel>> searchByReceipt(String term,int page) async {
    final res = await dio.get(baseUrl + 'search/${term.trim()}',
        queryParameters: {'by': SearchType.receipt.index,'page':page});

    if (res.statusCode == 200) {
      return (res.data['data'] as List)
          .map<ReceiptContainerModel>(
              (json) => ReceiptContainerModel.fromJson(json))
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<List<DeviceInfoModel>> searchByDevice(String term,int page) async {
    final res = await dio.get(baseUrl + 'search/$term',
        queryParameters: {'by': SearchType.device.index,'page':page});

    if (res.statusCode == 200) {
      return (res.data['data'] as List)
          .map<DeviceInfoModel>((json) => DeviceInfoModel.fromJson(json))
          .toList();
    }
    throw ServerException();
  }
}
