import 'package:flutter/material.dart';
import 'package:tech_care_app/app/app_localization.dart';

abstract class IlanguageDependentDisplay {
  String getDisplayValue(Locale locale);

  static String getDisplayString(BuildContext context, dynamic param) {
    if (param is IlanguageDependentDisplay) {
      return param.getDisplayValue(AppLocalizations.getLocale(context));
    } else {
      return param.toString();
    }
  }
}
