import 'package:tech_care_app/core/entities/translatable_value.dart';

class TranslatableValueModel extends TranslatableValue {
  TranslatableValueModel({required super.translations, super.object});

  TranslatableValueModel.fromEntity(TranslatableValue entity)
      : this(translations: entity.translations, object: entity.object);

  factory TranslatableValueModel.fromJson({
    Object? object,
    required String key,
    required Map<String, dynamic> json,
  }) {
    return TranslatableValueModel(
        object: object, translations: json[key] ?? {});
  }
}
