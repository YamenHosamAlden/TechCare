import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/core/util/app_colors.dart';

class CustomCountryCodePicker extends StatelessWidget {
  final void Function(String)? onChanged;
  final String? initialSelection;
  const CustomCountryCodePicker(
      {required this.onChanged, this.initialSelection, super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CountryCodePicker(
    dialogBackgroundColor: AppColors.alabasterColor,
    
        padding: EdgeInsets.zero,
        onChanged: (value) {
          onChanged!(value.dialCode!);
        },
        initialSelection: initialSelection,
        showFlag: true,
        showFlagDialog: true,
      ),
    );
  }
}
