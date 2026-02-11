import 'package:dio/dio.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/features/receipts_container_details/data/models/container_details_model.dart';
import 'package:tech_care_app/features/receipts_container_details/data/models/device_details_model.dart';
import 'package:tech_care_app/features/receipts_container_details/data/models/device_payment_details.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/receipts_container_details_page.dart';

abstract class ContainerDetailsRemoteDataSource {
  Future<ContainerDetailsModel> getContainerDetails(
      int containerId, ContainerDisplayType displayType);

  Future<ContainerDetailsModel> deleteReceipt(
    int containerId,
  );

  Future<void> editReceiptDetails(
    ContainerDetailsModel containerDetails,
    void Function(int, int)? onSendProgress,
  );
  Future<void> editDevice(
    int deviceId,
    DeviceDetailsModel deviceDetailsModel,
    void Function(int, int)? onSendProgress,
  );
  Future<DeviceDetailsModel> getDeviceDetailsById(
    int deviceId,
  );
  Future<void> deleteDevice(int deviceId);

  Future<DevicePaymentDetailsModel> getDevicePaymentDetails(
    int deviceId,
  );
}

final class ContainerDetailsRemoteDataSourceImpl
    implements ContainerDetailsRemoteDataSource {
  final Dio dio;

  ContainerDetailsRemoteDataSourceImpl({required this.dio});

  get baseUrl => ServerConfig().maintenanceServerAddress;

  @override
  Future<ContainerDetailsModel> getContainerDetails(
      int containerId, ContainerDisplayType displayType) async {
    final res = await dio.get(baseUrl + 'container/$containerId',
        queryParameters: {'type': displayType.index});

    // print(res.statusCode);
    // print(res.data);

    if (res.statusCode == 200) {
      return ContainerDetailsModel.fromJson(res.data['data']);
    }
    throw ServerException();
  }

  @override
  Future<ContainerDetailsModel> deleteReceipt(int containerId) async {
    final res = await dio.delete(
      baseUrl + 'container/$containerId',
    );

    // print(res.statusCode);
    // print(res.data);

    if (res.statusCode == 200) {
      return ContainerDetailsModel.fromJson(res.data['data']);
    }
    throw ServerException();
  }

  @override
  Future<void> editReceiptDetails(
    ContainerDetailsModel containerDetails,
    void Function(int, int)? onSendProgress,
  ) async {
    int containerId = containerDetails.id;
    FormData form = FormData.fromMap(containerDetails.toJson());

    final res = await dio.post(baseUrl + 'receipt/$containerId', data: form);

    if (res.statusCode == 200) {
      return;
    }
    throw ServerException();
  }

  @override
  Future<void> editDevice(
    int deviceId,
    DeviceDetailsModel deviceDetailsModel,
    final void Function(int, int)? onSendProgress,
  ) async {
    FormData form = FormData.fromMap(deviceDetailsModel.toJson());

    final res = await dio.post(baseUrl + "receipt/device/$deviceId",
        data: form, onSendProgress: onSendProgress);
    // print(res.data);
    if (res.statusCode == 200) {
      return;
    }
    throw ServerException();
  }

  @override
  Future<void> deleteDevice(int deviceId) async {
    final res = await dio.get(
      baseUrl + 'device/delete/$deviceId',
    );

    // print(res.statusCode);
    // print(res.data);

    if (res.statusCode == 200) {
      return;
    }
    throw ServerException();
  }

  @override
  Future<DeviceDetailsModel> getDeviceDetailsById(int deviceId) async {
    final res = await dio.get(
      baseUrl + 'device/$deviceId',
    );

    // print(res.statusCode);
    // print(res.data);

    if (res.statusCode == 200) {
      return DeviceDetailsModel.fromJson(res.data['data']);
    }
    throw ServerException();
  }

  @override
  Future<DevicePaymentDetailsModel> getDevicePaymentDetails(
      int deviceId) async {
    final res = await dio.get(
      baseUrl+"payment/$deviceId",
    );
    

    // print(res.statusCode);
    // print(res.data);

    if (res.statusCode == 200) {
      return DevicePaymentDetailsModel.fromJson(res.data['data']);
    }
    throw ServerException();
  }
}
