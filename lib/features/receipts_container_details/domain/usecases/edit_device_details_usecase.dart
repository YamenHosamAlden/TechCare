import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';

import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/features/receipt_details/data/models/device_info_model.dart';
import 'package:tech_care_app/features/receipt_details/domain/repositories/receipt_details_repository.dart';
import 'package:tech_care_app/features/receipts_container_details/data/models/device_info_model.dart'
    as containerModel;
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/repositories/container_details_repository.dart';

class EditDeviceDetailsUsecase extends Usecase<void, DeviceDetailsParams> {
  ContainerDetailsRepository containerDetailsRepository;
  ReceiptDetailsRepostiory receiptDetailsRepostiory;

  EditDeviceDetailsUsecase({
    required this.containerDetailsRepository,
    required this.receiptDetailsRepostiory,
  });
  @override
  Future<Either<Failure, void>> call(DeviceDetailsParams deviceDetailsParams) =>
      containerDetailsRepository
          .editDevice(
            deviceDetailsParams.deviceId,
            deviceDetailsParams.deviceDetails,
            deviceDetailsParams.onSendProgress,
          )
          .then((value) => value.fold((failure) => Left(failure), (v) {
                receiptDetailsRepostiory.editDeviceFromReceiptDetails(
                    deviceDetailsParams.deviceId,
                    DeviceInfoModel.fromDeviceDetails(getUpdatedDeviceDetaisl(
                        deviceDetailsParams.deviceDetails)));

                containerDetailsRepository
                    .editDeviceFromReceiptContainerDetails(
                        deviceDetailsParams.deviceId,
                        containerModel.DeviceInfoModel.fromDeviceDetails(
                            getUpdatedDeviceDetaisl(
                                deviceDetailsParams.deviceDetails)));
                return Right(Void);
              }));

  DeviceDetails getUpdatedDeviceDetaisl(DeviceDetails oldDeviceDetails) {
    return oldDeviceDetails.copyWith(
        deviceType: oldDeviceDetails.deviceType.copyWith(
            name: TranslatableValue(translations: {
      'ar': oldDeviceDetails.newDeviceType,
      'en': oldDeviceDetails.newDeviceType,
    })));
  }
}

class DeviceDetailsParams {
  final int deviceId;
  final DeviceDetails deviceDetails;
  final void Function(int, int)? onSendProgress;

  DeviceDetailsParams({
    required this.deviceId,
    required this.deviceDetails,
    this.onSendProgress,
  });
}
