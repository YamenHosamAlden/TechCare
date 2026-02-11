import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';

enum TimerStatus {
  running,
  paused,
  error,
  ;

  static TimerStatus fromString(String? status) {
    switch (status) {
      case 'running':
        return TimerStatus.running;
      case 'paused':
        return TimerStatus.paused;
      default:
        return TimerStatus.error;
    }
  }
}

class Process extends Equatable {
  final int time;
  final TimerStatus timerStatus;
  final List<ProcessReport>? reports;

  Process({
    required this.time,
    required this.timerStatus,
    required this.reports,
  });

  @override
  List<Object?> get props => [
        time,
        timerStatus,
        reports,
        reports?.length,
      ];
}
