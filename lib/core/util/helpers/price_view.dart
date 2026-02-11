import 'package:intl/intl.dart';

String addCommasToNumber(String number) {
  RegExp regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
  String result = number.replaceAllMapped(regExp, (Match match) => ',');
  return result;
}

String priceFormat(num number) {
  String strNumber = addCommasToNumber(
      NumberFormat.currency(symbol: '', decimalDigits: 2).format(number));
  return strNumber;
}
