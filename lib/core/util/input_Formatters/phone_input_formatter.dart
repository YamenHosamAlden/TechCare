import 'package:flutter/services.dart';

class ArabicNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final arabicRegExp = RegExp(r'[٠-٩]|\u06F0-\u06F9');
    final oldValueString = oldValue.text;
    final newValueString = newValue.text;
    String formattedValue = newValueString; 

    if (arabicRegExp.hasMatch(newValueString)) {
      formattedValue = convertArabicToEnglish(newValueString);
    }

    if (oldValueString != formattedValue) {
      return TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    } else {
      return newValue;
    }
  }

  String convertArabicToEnglish(String input) {
    final arabicToEnglish = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
      '\u06F0': '0',
      '\u06F1': '1',
      '\u06F2': '2',
      '\u06F3': '3',
      '\u06F4': '4',
      '\u06F5': '5',
      '\u06F6': '6',
      '\u06F7': '7',
      '\u06F8': '8',
      '\u06F9': '9',
    };
    return input.replaceAllMapped(
        RegExp(arabicToEnglish.keys.join('|')), (match) {
      return arabicToEnglish[match.group(0)]!;
    });
  }
}
