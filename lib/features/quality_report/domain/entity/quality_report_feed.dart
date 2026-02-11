import 'package:equatable/equatable.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/external_item.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/group_user.dart';

class QualityReportFeed extends Equatable {
  final String customer_phone;
  final List<ExternalItem> externalItems;
  final List<GroupUser> users;

  QualityReportFeed(
      {required this.customer_phone, required this.users,required this.externalItems});

  @override
  List<Object?> get props => [
        customer_phone,
        users,
      ];
}
