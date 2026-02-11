import 'package:dio/dio.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device.dart';
import 'package:path/path.dart';

class DeviceModel extends Device {
  DeviceModel({
    super.deviceCode,
    super.serialNumber,
    super.brand,
    super.model,
    super.itemName,
    super.qty,
    super.problemDescription,
    super.attachments,
    super.sourceCompany,
    super.warrantyType,
    super.reasonForWarranty,
    required super.images,
  });

  DeviceModel.fromEntity(Device device)
      : this(
          deviceCode: device.deviceCode,
          serialNumber: device.serialNumber,
          brand: device.brand,
          model: device.model,
          itemName: device.itemName ?? '',
          qty: device.qty,
          problemDescription: device.problemDescription,
          attachments: device.attachments,
          sourceCompany: device.sourceCompany,
          warrantyType: device.warrantyType,
          reasonForWarranty: device.reasonForWarranty,
          images: device.images,
        );

  Map<String, dynamic> toJson() {
    final json = {
      'device_code': deviceCode,
      'device_serial_number': serialNumber,
      'device_type': brand,
      'device_model': model,
      'device_name': itemName,
      'device_qty': qty,
      'problem_description': problemDescription,
      'device_attachments': attachments,
      'company_id': sourceCompany?.id,
      'device_warranty': warrantyType?.object,
      'warranty_reason': reasonForWarranty,
      'images_count': images.length
    };
    for (var i = 0; i < images.length; i++) {
      final imageFile = images.elementAt(i);
      json.addAll({
        'image$i': MultipartFile.fromFileSync('.' + imageFile.path,
            filename: basename(imageFile.path))
      });
    }
    return json;
  }
}
