import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/container_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_payment_details.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/receipts_container_details_bloc/receipts_container_details_bloc.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/receipts_container_details_page.dart';

abstract class ContainerDetailsRepository {
  Future<Either<Failure, ContainerDetails>> getContainerDetails(
      int containerId, ContainerDisplayType displayType);

  Future<Either<Failure, void>> editReceiptDetails(
    ContainerDetails containerDetails,
    void Function(int, int)? onSendProgress,
  );
  void editReceiptFromReceiptContainerDetails(
      ContainerDetails containerDetails);
  Future<Either<Failure, void>> deleteReceipt(int containerId);

  Future<Either<Failure, void>> editDevice(
    int deviceId,
    DeviceDetails deviceDetails,
    final void Function(int, int)? onSendProgress,
  );
  Future<Either<Failure, DeviceDetails>> getDeviceDetailsById(int deviceId);

  Future<Either<Failure, void>> deleteDevice(int deviceId);

  Future<Either<Failure, Stream<ReceiptsContainerDetailsEvent>>>
      get receiptsContainerDetailsEventStream;

  void removeDeviceFromReceiptContainerDetails(int deviceId);
  void editDeviceFromReceiptContainerDetails(
      int deviceId, DeviceInfo deviceInfo);

  Future<Either<Failure, DevicePaymentDetails>> getDevicePaymentDetails(int deviceId);
}
