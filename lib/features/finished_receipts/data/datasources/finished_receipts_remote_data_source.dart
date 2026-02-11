import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/finished_receipts/data/models/checkout_form_data_model.dart';
import 'package:tech_care_app/features/finished_receipts/data/models/finishing_report_model.dart';
import 'package:tech_care_app/features/saerch/data/model/receipt_containter_model.dart';

abstract class FinishedReceiptsRemoteDataSource {
  Future<List<ReceiptContainerModel>> getFinishedReceipts(int page);
  Future<FinishingReportModel> getFinishingReport(int containerid);
  Future<void> checkout(
      int containerId, CheckoutFormDataModel checkoutFormDataModel);
}

final class FinishedReceiptsRemoteDataSourceImpl
    implements FinishedReceiptsRemoteDataSource {
  final Dio dio;

  FinishedReceiptsRemoteDataSourceImpl({required this.dio});

  get baseUrl => ServerConfig().maintenanceServerAddress;

  @override
  Future<List<ReceiptContainerModel>> getFinishedReceipts(int page) async {
    final res =
        await dio.get(baseUrl + 'finished', queryParameters: {"page": page});

    if (res.statusCode == 200) {
      return (res.data['data'] as List)
          .map<ReceiptContainerModel>(
              (containerJson) => ReceiptContainerModel.fromJson(containerJson))
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<FinishingReportModel> getFinishingReport(int containerid) async {
    final res = await dio.get(baseUrl + 'deliveryReport/$containerid');

    // print(res.statusCode);
    // print(res.data);

    if (res.statusCode == 200) {
      return FinishingReportModel.fromJson(res.data['data']);
    }

    throw ServerException();
  }

  @override
  Future<void> checkout(
    int containerId,
    CheckoutFormDataModel checkoutFormDataModel,
  ) async {
    final req = {
      'container_id': containerId,
      'note': checkoutFormDataModel.note,
      'devices': checkoutFormDataModel.amounts.map((e) => e.toJson()).toList(),
    };
    // print(req);
    final res = await dio.post(baseUrl + 'checkout', data: req);

    // print(res.statusCode);
    // print(res.data);
    if (res.statusCode == 200 && res.data['success'] == true) {
      return;
    }
    throw ServerException();
  }
}
