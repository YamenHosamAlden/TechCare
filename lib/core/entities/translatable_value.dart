import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/interface/%20ilanguage%D9%80dependent%D9%80display.dart';
import 'package:flutter/foundation.dart';
import 'package:tech_care_app/routes/app_router.dart';

class TranslatableValue extends Equatable implements IlanguageDependentDisplay {
  final Object? object;
  final Map<String, dynamic> translations;

  TranslatableValue({required this.translations, this.object});

  TranslatableValue.fromTranslations(
      {required Translation translations, Object? object})
      : this(translations: translations.toMapEntity(), object: object);

  @override
  List<Object?> get props => [object, translations];

  @override
  String getDisplayValue(Locale locale) {
    return translations[locale.languageCode] ?? 'Unsupported language';
  }

  @override
  bool operator ==(Object object) {
    if (object is! TranslatableValue) return false;

    return this.object == object.object &&
        mapEquals(this.translations, object.translations);
  }

  String get tr =>
      getDisplayValue(AppLocalizations.of(AppRouter.navigator.context)!.locale);
}

class Translation {
  final String ar;
  final String en;

  Translation({
    required this.ar,
    required this.en,
  });
  Map<String, dynamic> toMapEntity() => {
        'en': en,
        'ar': ar,
      };
}

// extension TranslatableValueEx on TranslatableValue {
//   String get tr =>
//       getDisplayValue(AppLocalizations.of(AppRouter.navigator.context)!.locale);
// }
