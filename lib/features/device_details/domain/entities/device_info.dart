import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';

class DeviceInfo extends Equatable {
  final int id;
  final String deviceCode;
  final int receiptId;
  final String? serialNumber;
  final DeviceType? type;
  final String? model;
  final String? itemName;
  final String? qty;
  final String? problemDescription;
  final String? attachments;
  final String? sourceCompany;
  final TranslatableValue? warrantyType;
  final String? reasonForWarranty;
  final TranslatableValue? status;
  final TranslatableValue? statusLable;
  final String? assignName;
  final int? assignId;
  final List<String> images;

  DeviceInfo({
    required this.id,
    required this.deviceCode,
    required this.receiptId,
    this.serialNumber,
    this.type,
    this.model,
    this.itemName,
    this.qty,
    this.problemDescription,
    this.attachments,
    this.sourceCompany,
    this.warrantyType,
    this.reasonForWarranty,
    this.status,
    this.statusLable,
    this.assignName,
    this.assignId,
    required this.images,
  });

  DeviceInfo copyWith({
    String? serialNumber,
    DeviceType? type,
    String? model,
    String? itemName,
    String? qty,
    String? problemDescription,
    String? attachments,
    String? sourceCompany,
    TranslatableValue? warrantyType,
    String? reasonForWarranty,
    TranslatableValue? status,
    TranslatableValue? statusLable,
    String? assignName,
    int? assignId,
    List<String>? images,
    bool removeAssignment = false,
  }) =>
      DeviceInfo(
          id: this.id,
          receiptId: this.receiptId,
          deviceCode: deviceCode,
          serialNumber: serialNumber ?? this.serialNumber,
          type: type ?? this.type,
          model: model ?? this.model,
          itemName: itemName ?? this.itemName,
          qty: qty ?? this.qty,
          problemDescription: problemDescription ?? this.problemDescription,
          attachments: attachments ?? this.attachments,
          sourceCompany: sourceCompany ?? this.sourceCompany,
          warrantyType: warrantyType ?? this.warrantyType,
          reasonForWarranty: reasonForWarranty ?? this.reasonForWarranty,
          images: images ?? List.of(this.images),
          assignId: removeAssignment ? null : assignId ?? this.assignId,
          assignName: removeAssignment ? null : assignName ?? this.assignName,
          status: status ?? this.status,
          statusLable: statusLable ?? this.statusLable);

  @override
  List<Object?> get props => [
        id,
        receiptId,
        serialNumber,
        type,
        model,
        itemName,
        qty,
        problemDescription,
        attachments,
        sourceCompany,
        warrantyType,
        status,
        assignId,
        statusLable,
        assignName,
        reasonForWarranty,
        images.length,
        images,
      ];
}
