import 'package:tech_care_app/features/quality_report/data/model/group_user_model.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/quality_report.dart';

class QualityReportModel extends QualityReport {
  final GroupUserModel? user;
  QualityReportModel({
    required super.isAccepted,
    required super.testDuration,
    required super.fixedCost,
    required super.isSalesReturn,
    required super.isNotified,
    required super.isReturnToGroup,
    required super.report,
    required this.user,
  }) : super(user: user);

  Map<String, dynamic> toJson() {
    return {
      'accepted': isAccepted,
      'report': report,
      'test_duration': testDuration,
      'fixed_cost': fixedCost,
      'customer_notified': isNotified,
      'sales_return': isSalesReturn,
      'return_to_group': isReturnToGroup,
      'return_user': user?.id,
    };
  }

  factory QualityReportModel.fromEntity(QualityReport qualityReport) {
    return QualityReportModel(
      report: qualityReport.report,
      isAccepted: qualityReport.isAccepted,
      testDuration: qualityReport.testDuration,
      fixedCost: qualityReport.fixedCost,
      isSalesReturn: qualityReport.isSalesReturn,
      isNotified: qualityReport.isNotified,
      isReturnToGroup: qualityReport.isReturnToGroup,
      user: qualityReport.user == null
          ? null
          : GroupUserModel.fromEntity(qualityReport.user!),
    );
  }
}
