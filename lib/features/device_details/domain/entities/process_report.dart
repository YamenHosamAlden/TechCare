import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/device_details/domain/entities/maintenance_item.dart';

class ProcessReport extends Equatable {
  final String text;
  final String createdBy;
  final ProcessReportType type;
  final DateTime createdAt;
  final bool isAccepted;
  final String time;
  final bool salesReturn;
  final bool returnedToGroup;
  final String? returnedToUser;
  final bool isRecentlyAdded;
  final String? testDuration;

  final List<MaintenanceItem>? items;

  ProcessReport({
    required this.text,
    required this.createdBy,
    required this.type,
    required this.createdAt,
    required this.items,
    required this.salesReturn,
    required this.returnedToGroup,
    required this.returnedToUser,
    required this.isAccepted,
    required this.time,
    this.testDuration,
    this.isRecentlyAdded = false,
  });

  ProcessReport copyWith({
    String? text,
    String? createdBy,
    ProcessReportType? type,
    DateTime? createdAt,
    bool? isAccepted,
    String? time,
    bool? salesReturn,
    bool? returnedToGroup,
    String? returnedToUser,
    bool? isRecentlyAdded,
    String? testDuration,
  }) =>
      ProcessReport(
        text: text ?? this.text,
        createdBy: createdBy ?? this.createdBy,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        isAccepted: isAccepted ?? this.isAccepted,
        items: items ?? this.items,
        time: time ?? this.time,
        salesReturn: salesReturn ?? this.salesReturn,
        returnedToGroup: returnedToGroup ?? this.returnedToGroup,
        returnedToUser: returnedToUser ?? this.returnedToUser,
        isRecentlyAdded: isRecentlyAdded ?? this.isRecentlyAdded,
        testDuration:testDuration?? this.testDuration,
      );

  @override
  List<Object?> get props => [
        type,
        createdBy,
        createdAt,
        items,
        items?.length,
        time,
        salesReturn,
        returnedToGroup,
        returnedToUser,
        isRecentlyAdded,
        testDuration,
      ];
}

enum ProcessReportType {
  NOTE,
  MAINTENANCE,
  QUALITY,
  UNKOWN;

  static ProcessReportType fromString(String? type) {
    switch (type) {
      case 'note':
        return ProcessReportType.NOTE;
      case 'maintenance':
        return ProcessReportType.MAINTENANCE;
      case 'quality':
        return ProcessReportType.QUALITY;
      default:
        return ProcessReportType.UNKOWN;
    }
  }
}
