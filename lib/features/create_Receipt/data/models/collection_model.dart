import 'package:tech_care_app/features/create_receipt/data/models/device_model.dart';
import 'package:tech_care_app/features/create_receipt/data/models/employee_model.dart';
import 'package:tech_care_app/features/create_receipt/data/models/maintenance_group_model.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/collection.dart';

class CollectionModel extends Collection {
  final List<DeviceModel> devices;
  final MaintenanceGroupModel? maintenanceGroup;
  final EmployeeModel? employee;

  CollectionModel({
    this.maintenanceGroup,
    this.employee,
    required this.devices,
  }) : super(
            maintenanceGroup: maintenanceGroup,
            employee: employee,
            devices: devices);

  // factory CollectionModel.fromEntity(Collection collection) => CollectionModel(
  //       maintenanceGroup:
  //           MaintenanceGroupModel.fromEntity(collection.maintenanceGroup!),
  //       employee: collection.employee == null
  //           ? null
  //           : EmployeeModel.fromEntity(collection.employee!),
  //       devices: collection.devices
  //           .map((device) => DeviceModel.fromEntity(device))
  //           .toList(),
  //     );

  CollectionModel.fromEntity(Collection collection)
      : this(
          maintenanceGroup:
              MaintenanceGroupModel.fromEntity(collection.maintenanceGroup!),
          employee: collection.employee == null
              ? null
              : EmployeeModel.fromEntity(collection.employee!),
          devices: collection.devices
              .map((device) => DeviceModel.fromEntity(device))
              .toList(),
        );

  Map<String, dynamic> toJson() {
    return {
      'group_id': maintenanceGroup?.id,
      'user_id': employee?.id ,
      'devices': devices.map((deviceModel) => deviceModel.toJson()).toList(),
    };
  }

}
