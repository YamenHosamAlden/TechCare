import 'package:tech_care_app/features/quality_report/domain/entity/external_item.dart';

class ExternalItemModel extends ExternalItem {
  ExternalItemModel({required super.id, required super.name, super.price});

  factory ExternalItemModel.fromJson(Map<String, dynamic> json) {
    return ExternalItemModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory ExternalItemModel.fromEntity(ExternalItem entity) {
    return ExternalItemModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
      };
}
