bool isPhoneNumber(String number) {
  return number.length > 3;
  // RegExp phoneRegex = RegExp(r'^\+?(\d{1,3})?\s?-?(\d{9,15})$');

  // return phoneRegex.hasMatch(number);
}
