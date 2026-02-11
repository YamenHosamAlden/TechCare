import 'package:tech_care_app/features/maintenance_report/data/models/installed_item_model.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/maintenance_report.dart';

class MaintenanceReportModel extends MaintenanceReport {
  final List<InstalledItemModel> installedItems;

  MaintenanceReportModel({
    required super.id,
    required super.createdBy,
    required super.createdAt,
    required this.installedItems,
    required super.report,
  })
  : super(installedItems: installedItems)
  ;

  factory MaintenanceReportModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceReportModel(
      id: json['id'],
      createdAt: DateTime.now(),
      installedItems: (json['items'] as List)
          .map((itemJson) => InstalledItemModel.fromJson(itemJson))
          .toList(),
      report: 'report',
      createdBy: 'osama',
    );
  }

  factory MaintenanceReportModel.fromEntity(
      MaintenanceReport maintenanceReport) {
    return MaintenanceReportModel(
        id: maintenanceReport.id,
        createdBy: maintenanceReport.createdBy,
        createdAt: maintenanceReport.createdAt,
        installedItems: maintenanceReport.installedItems
            .map((installedItems) =>
                InstalledItemModel.fromEntity(installedItems))
            .toList(),
        report: maintenanceReport.report);
  }

  Map<String, dynamic> toJson() {
    return {
      'items': installedItems.map((item) => item.tojson()).toList(),
      'report': report,
    };
  }
}
