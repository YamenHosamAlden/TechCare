import 'package:tech_care_app/core/entities/translatable_value.dart';

List<TranslatableValue> listOfPriorty() {
  return [
    TranslatableValue.fromTranslations(
        object: 'Internal',
        translations: Translation(ar: 'داخلي', en: 'Internal')),
    TranslatableValue.fromTranslations(
        object: 'Shipping',
        translations: Translation(ar: 'شحن', en: 'Shipping')),
    TranslatableValue.fromTranslations(
        object: 'Urgent',
        translations: Translation(ar: 'مستعجل', en: 'Urgent')),
  ];
}
