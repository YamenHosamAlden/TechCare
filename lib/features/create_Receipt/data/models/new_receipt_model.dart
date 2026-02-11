import 'package:tech_care_app/features/create_receipt/data/models/collection_model.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/collection.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/new_receipt.dart';

class NewRerceiptModel extends NewReceipt {
  final List<CollectionModel> collections;

  NewRerceiptModel({
    required super.customerName,
    required super.customerPhone,
    required super.priority,
    required super.shippingNumber,
    required this.collections,
  }) : super(collections: collections);

  // factory NewRerceiptModel.fromEntity(NewReceipt entity) => NewRerceiptModel(
  //       customerName: entity.customerName,
  //       customerPhone: entity.customerPhone,
  //       priority: entity.priority,
  //       shippingNumber: entity.shippingNumber,
  //       collections: entity.collections
  //           .map((Collection collection) =>
  //               CollectionModel.fromEntity(collection))
  //           .toList(),
  //     );

  NewRerceiptModel.fromEntity(NewReceipt entity)
      : this(
          customerName: entity.customerName,
          customerPhone: entity.customerPhone,
          priority: entity.priority,
          shippingNumber: entity.shippingNumber,
          collections: entity.collections
              .map((Collection collection) =>
                  CollectionModel.fromEntity(collection))
              .toList(),
        );

  Map<String, dynamic> toJson() {

    return {
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'priority': priority?.object,
      'priority_shipping_number': shippingNumber,
      'collections':
          collections.map((collection) => collection.toJson()).toList(),
    };
  }
}
