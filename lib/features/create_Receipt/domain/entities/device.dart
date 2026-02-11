import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/company.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';

class Device extends Equatable {
  final String? deviceCode;
  final String? serialNumber;
  final String? brand;
  final String? model;
  final String? itemName;
  final String? qty;
  final String? problemDescription;
  final String? attachments;
  final Company? sourceCompany;
  final TranslatableValue? warrantyType;
  final String? reasonForWarranty;
  final List<File> images;

  Device({
    this.deviceCode,
    this.serialNumber,
    this.brand,
    this.model,
    this.itemName,
    this.qty,
    this.problemDescription,
    this.attachments,
    this.sourceCompany,
    this.warrantyType,
    this.reasonForWarranty,
    required this.images,
  });

  Device copyWith({
    String? deviceCode,
    String? serialNumber,
    String? brand,
    String? model,
    String? itemName,
    String? qty,
    String? problemDescription,
    String? attachments,
    Company? sourceCompany,
    TranslatableValue? warrantyType,
    String? reasonForWarranty,
    List<File>? images,
  }) =>
      Device(
        deviceCode: deviceCode ?? this.deviceCode,
        serialNumber: serialNumber ?? this.serialNumber,
        brand: brand ?? this.brand,
        model: model ?? this.model,
        itemName: itemName ?? this.itemName,
        qty: qty ?? this.qty,
        problemDescription: problemDescription ?? this.problemDescription,
        attachments: attachments ?? this.attachments,
        sourceCompany: sourceCompany ?? this.sourceCompany,
        warrantyType: warrantyType ?? this.warrantyType,
        reasonForWarranty: reasonForWarranty ?? this.reasonForWarranty,
        images: images ?? List.of(this.images),
      );

  @override
  List<Object?> get props => [
        deviceCode,
        serialNumber,
        brand,
        model,
        itemName,
        qty,
        problemDescription,
        attachments,
        sourceCompany,
        warrantyType,
        reasonForWarranty,
        images.length,
        images,
      ];
}
