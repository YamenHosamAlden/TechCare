import 'package:tech_care_app/features/device_details/data/models/process_report_model.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process.dart';

class ProcessModel extends Process {
  ProcessModel({
    required super.time,
    required super.timerStatus,
    required super.reports,
  });

  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    return ProcessModel(
      time: json['timer'] ?? 0,
      timerStatus: TimerStatus.fromString(json['timerStatus']),
      reports: (json['reports'] as List)
          .map((reportJson) => ProcessReportModel.fromJson(reportJson))
          .toList(),
    );
  }
}
