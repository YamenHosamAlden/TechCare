import 'package:flutter/services.dart';
import 'package:tech_care_app/core/util/helpers/price_view.dart';

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text.replaceAll(',', '');
    if (newValueString.isEmpty) return newValue;

    if (double.tryParse(newValueString) == null) return oldValue;

    final formattedValue = addCommasToNumber(newValueString);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }


}
