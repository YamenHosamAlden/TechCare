import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/group_user.dart';

class QualityReport extends Equatable {
  final bool isAccepted;
  final String testDuration;
  final String fixedCost;
  final bool isSalesReturn;
  final bool isNotified;
  final bool isReturnToGroup;
  final GroupUser? user;
  // final List<ExternalItem> pricedExternalItems;
  final String report;

  QualityReport({
    required this.isAccepted,
    required this.testDuration,
    required this.fixedCost,
    required this.isSalesReturn,
    required this.isNotified,
    required this.isReturnToGroup,
    required this.user,
    // required this.pricedExternalItems,
    required this.report,
  });

  @override
  List<Object?> get props => [
        isAccepted,
        testDuration,
        fixedCost,
        isSalesReturn,
        isNotified,
        isReturnToGroup,
        user,
        report,
      ];
}
