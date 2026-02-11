import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tech_care_app/routes/app_router.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(
        AppLocalizations.of(context)!.locale.languageCode);
  }

  static TextDirection getTextDirection(BuildContext context) {
    return isDirectionRTL(context) ? TextDirection.ltr : TextDirection.rtl;
  }

  static Locale getLocale(BuildContext context) =>
      AppLocalizations.of(context)!.locale;

  static const LocalizationsDelegate delegate = _AppLocalizatoinsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? "Undefined value";
  }
}

class _AppLocalizatoinsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizatoinsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

extension Localization on String {
  String get tr =>
      AppLocalizations.of(AppRouter.navigator.context)!.translate(this);
}
