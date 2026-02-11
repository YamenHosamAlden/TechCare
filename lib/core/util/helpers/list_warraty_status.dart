import 'package:tech_care_app/core/entities/translatable_value.dart';

List<TranslatableValue> getWarratyStatusChoises() => [
      TranslatableValue.fromTranslations(
          object: 'in',
          translations: Translation(ar: 'ضمن الكفالة', en: 'In warranty')),
      TranslatableValue.fromTranslations(
          object: 'out',
          translations: Translation(ar: 'خارج الكفالة', en: 'Out of warranty')),
      TranslatableValue.fromTranslations(
          object: 're',
          translations: Translation(ar: 'إعادة صيانة', en: 'Re-maintenance')),
      TranslatableValue.fromTranslations(
          object: 'unknown',
          translations: Translation(ar: 'غير معروف', en: 'Unknown')),
    ];

extension warrantyMapper on String {
  TranslatableValue get warrantyStatus {
    return getWarratyStatusChoises()
        .firstWhere((element) => element.object == this);
  }
}
