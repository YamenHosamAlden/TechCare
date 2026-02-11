import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/saerch/data/model/receipt_containter_model.dart';

abstract class RecentlyReceiptsDataSource {
  Future<List<ReceiptContainerModel>> getRecentlyAddedReceipts(int page);
}

class RecentlyReceiptsDataSourceImpl
    implements RecentlyReceiptsDataSource {
  Dio dio;
  RecentlyReceiptsDataSourceImpl({required this.dio});

  get baseUrl => ServerConfig().maintenanceServerAddress;
  @override
  Future<List<ReceiptContainerModel>> getRecentlyAddedReceipts(int page) async {
    final res = await dio.get(baseUrl + 'recent',queryParameters: {"page":page});

    if (res.statusCode == 200) {
      return (res.data['data'] as List)
          .map<ReceiptContainerModel>(
              (recentyAddedReceipt) => ReceiptContainerModel.fromJson(recentyAddedReceipt))
          .toList();
    }
    throw ServerException();
  }
}
