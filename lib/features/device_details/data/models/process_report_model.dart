import 'package:tech_care_app/features/device_details/data/models/maintenance_item_model.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';

class ProcessReportModel extends ProcessReport {
  final List<MaintenanceItemModel> items;
  ProcessReportModel({
    required super.text,
    required super.createdBy,
    required super.type,
    required super.createdAt,
    required super.isAccepted,
    required super.time,
    required super.salesReturn,
    required super.returnedToGroup,
    required super.returnedToUser,
    required this.items,
  required   super.testDuration,
  }) : super(items: items);

  factory ProcessReportModel.fromJson(Map<String, dynamic> json) {
    return ProcessReportModel(
        text: json['text'],
        createdBy: json['createdBy'],
        type: ProcessReportType.fromString(json['reportType']),
        createdAt: DateTime.parse(json['date']),
        isAccepted: json['done'] == 1,
        time: json['time'].toString(),
        salesReturn: json['salesReturn'],
        returnedToGroup: json['returnedToGroup'],
        returnedToUser: json['returnedToUser']?['name'],
        testDuration:json['testDuration'],
        items: ((json['items'] ?? []) as List)
            .map((itemJson) => MaintenanceItemModel.fromJson(itemJson))
            .toList());
  }
}
