import 'package:tech_care_app/features/quality_report/data/model/external_item_model.dart';

import 'group_user_model.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/quality_report_feed.dart';

class QualityReportFeedModel extends QualityReportFeed {
  final List<GroupUserModel> users;
  final List<ExternalItemModel> externalItems;

  QualityReportFeedModel({
    required super.customer_phone,
    required this.users,
    required this.externalItems,
  }) : super(
          users: users,
          externalItems: externalItems,
        );

  factory QualityReportFeedModel.fromJson(Map<String, dynamic> json) {
    return QualityReportFeedModel(
      customer_phone: json['customerPhone'] ?? '',
      users: List<GroupUserModel>.from(
        json['groupUsers']?.map((user) => GroupUserModel.fromJson(user)) ?? [],
      ),
      externalItems: List<ExternalItemModel>.from(
        json['externalItems']?.map((item) => ExternalItemModel.fromJson(item)) ??
            [],
      ),
    );
  }
}
