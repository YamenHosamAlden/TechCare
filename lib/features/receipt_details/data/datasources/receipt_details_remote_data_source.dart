import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/receipt_details/data/models/receipt_details_model.dart';
import 'package:tech_care_app/features/receipts/data/models/receipts_model.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';

abstract class ReceiptDetailsRemoteDataSource {
  Future<ReceiptDetailsModel> receiptDetailsById(
      int receiptID, ReceiptDisplayType receiptDisplayType);

  Future<ReceiptDetailsModel> receiptDetailsByDeviceCode(
      String deviceCode, ReceiptDisplayType receiptDisplayType);

  Future<ReceiptModel> ReceiveDevices(List<String> deviceCodes);
 
}

class ReceiptDetailsRemoteDataSourceImpl
    implements ReceiptDetailsRemoteDataSource {
  final Dio dio;

  ReceiptDetailsRemoteDataSourceImpl({required this.dio});

  String get baseUrl => ServerConfig().maintenanceServerAddress;

  @override
  Future<ReceiptDetailsModel> receiptDetailsById(
      int receiptID, ReceiptDisplayType receiptDisplayType) async {
    final res = await dio.get(
      baseUrl + 'receipt/$receiptID',
      queryParameters: {'type': receiptDisplayType.index},
    );
    // print('respone data :' + res.data.toString());
    if (res.statusCode == 200) {
      return ReceiptDetailsModel.fromJson(res.data['data']);
    }
    throw ServerException();
  }

  @override
  Future<ReceiptDetailsModel> receiptDetailsByDeviceCode(
      String deviceCode, ReceiptDisplayType receiptDisplayType) async {
    // print('''receipt type ${receiptDisplayType.index}''');
    final res = await dio.get(
      baseUrl + 'receipt/$deviceCode',
      queryParameters: {
        'type': receiptDisplayType.index,
        'code': true,
      },
    );
    // print('respone data :' + res.data.toString());
    if (res.statusCode == 200) {
      return ReceiptDetailsModel.fromJson(res.data['data']);
    }

    throw ServerException();
  }

  @override
  Future<ReceiptModel> ReceiveDevices(List<String> deviceCodes) async {
    final res = await dio.post(baseUrl + 'receive', data: {
      'device_codes': deviceCodes,
    });

    if (res.statusCode == 200 && res.data['success'] == true) {
      return ReceiptModel.fromJson(res.data['data']);
    } else {
      throw ServerException();
    }
  }


}
