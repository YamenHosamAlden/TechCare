import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/iinstalled_item.dart';

class MaintenanceReport extends Equatable {
  final int? id;
  final String? createdBy;
  final DateTime? createdAt;
  final List<InstalledItem> installedItems;
  final String report;

  MaintenanceReport({
    this.id,
    this.createdBy,
    this.createdAt,
    required this.installedItems,
    required this.report,
  });

  MaintenanceReport copyWith({
    int? id,
    String? createdBy,
    DateTime? createdAt,
    List<InstalledItem>? installedItems,
    String? report,
  }) =>
      MaintenanceReport(
        id: id ?? this.id,
        createdBy: createdBy ?? createdBy,
        createdAt: createdAt ?? createdAt,
        installedItems: installedItems ?? List.from(this.installedItems),
        report: report ?? this.report,
      );

  @override
  List<Object?> get props => [
        id,
        createdBy,
        createdAt,
        installedItems,
        report,
      ];
}
