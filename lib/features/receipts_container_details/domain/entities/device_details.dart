import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/company.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';

class DeviceDetails extends Equatable {
  final String deviceCode;
  final String deviceSerialNumber;
  final DeviceType deviceType;
  final String newDeviceType;
  final String deviceModel;
  final String deviceName;
  final String deviceQty;
  final String problemDescription;
  final String deviceAttachments;
  final Company company;
  final TranslatableValue deviceWarranty;
  final String warrantyReason;
  final List<String> images;
  final List<String>? deletedImages;
  final List<File>? fileImages;

  DeviceDetails(
      {required this.deviceCode,
      required this.deviceSerialNumber,
      required this.deviceType,
      String? newDeviceType,
      required this.deviceModel,
      required this.deviceName,
      required this.deviceQty,
      required this.problemDescription,
      required this.deviceAttachments,
      required this.company,
      required this.deviceWarranty,
      required this.warrantyReason,
      required this.images,
      List<String>? deletedImages,
      List<File>? fileImages})
      : this.fileImages = fileImages ?? [],
        this.deletedImages = deletedImages ?? [],
        this.newDeviceType = newDeviceType ?? '';

  DeviceDetails copyWith({
    final String? deviceCode,
    final String? deviceSerialNumber,
    final DeviceType? deviceType,
    final String? newDeviceType,
    final String? deviceModel,
    final String? deviceName,
    final String? deviceQty,
    final String? problemDescription,
    final String? deviceAttachments,
    final Company? company,
    final TranslatableValue? deviceWarranty,
    final String? warrantyReason,
    final List<String>? images,
    final List<String>? deletedImages,
    final List<File>? fileImages,
  }) =>
      DeviceDetails(
        deviceCode: deviceCode ?? this.deviceCode,
        deviceSerialNumber: deviceSerialNumber ?? this.deviceSerialNumber,
        deviceType: deviceType ?? this.deviceType,
        newDeviceType: newDeviceType ?? this.newDeviceType,
        deviceModel: deviceModel ?? this.deviceModel,
        deviceName: deviceName ?? this.deviceName,
        deviceQty: deviceQty ?? this.deviceQty,
        problemDescription: problemDescription ?? this.problemDescription,
        deviceAttachments: deviceAttachments ?? this.deviceAttachments,
        company: company ?? this.company,
        deviceWarranty: deviceWarranty ?? this.deviceWarranty,
        warrantyReason: warrantyReason ?? this.warrantyReason,
        images: images ?? List.of(this.images),
        deletedImages: deletedImages ?? List.of(this.deletedImages!),
        fileImages: fileImages ?? List.of(this.fileImages!),
      );

  @override
  List<Object?> get props => [
        deviceCode,
        deviceSerialNumber,
        deviceType,
        newDeviceType,
        deviceModel,
        deviceName,
        deviceQty,
        problemDescription,
        deviceAttachments,
        company,
        deviceWarranty,
        warrantyReason,
        images,
        fileImages,
        deletedImages
      ];
}
