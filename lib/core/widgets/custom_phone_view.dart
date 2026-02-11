import 'package:flutter/material.dart';
import 'package:tech_care_app/app/app_localization.dart';

class CustomPhoneView extends StatelessWidget {
  final String phone;
  final TextStyle? style;
  const CustomPhoneView({
    required this.phone,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      phone,
      textDirection: TextDirection.ltr,
      textAlign: AppLocalizations.isDirectionRTL(context)
          ? TextAlign.end
          : TextAlign.start,
      style: style,
    );
  }
}
