// import 'package:flutter/services.dart';

// class TimeTextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final text = newValue.text;

//     // If the text is empty or backspace is pressed, return early
//     if (text.isEmpty || oldValue.text.length > newValue.text.length) {
//       return newValue;
//     }

//     // Remove any non-numeric characters except colon
//     String filteredText = text.replaceAll(RegExp(r'[^0-9:]'), '');

//     // Ensure the first two digits are between 00 and 23
//     if (filteredText.length > 2) {
//       int hours = int.parse(filteredText.substring(0, 2));
//       if (hours > 23) {
//         filteredText = '23' + filteredText.substring(2);
//       }
//     }

//     // Ensure the last two digits are between 00 and 59
//     if (filteredText.length > 4) {
//       int minutes = int.parse(filteredText.substring(2, 4));
//       if (minutes > 59) {
//         filteredText = filteredText.substring(0, 2) + '59';
//       }
//     }

//     // Add colon between hours and minutes
//     if (filteredText.length >= 2) {
//       filteredText =
//           filteredText.substring(0, 2) + ':' + filteredText.substring(2);
//     }

//     // If the user attempts to enter more than 5 characters, stop the input
//     if (filteredText.length > 5) {
//       filteredText = filteredText.substring(0, 5);
//     }

//     return newValue.copyWith(
//       text: filteredText,
//       selection: TextSelection.collapsed(offset: filteredText.length),
//     );
//   }
// }
