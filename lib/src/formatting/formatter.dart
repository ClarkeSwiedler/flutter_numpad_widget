import 'numpad_format.dart';

export 'numpad_format.dart';

String formatRawString(String rawString, NumpadFormat format) {
  switch (format) {
    case NumpadFormat.CURRENCY:
      return _numberStringToDollarString(rawString);
    case NumpadFormat.PHONE:
      return _numberStringToPhoneNumber(rawString);
    case NumpadFormat.PIN4:
      return _pinToObfuscated(rawString);
    default:
      return rawString;
  }
}

String _numberStringToDollarString(String valueString) {
  var rawString = valueString.padLeft(3, '0');
  var dollarString = '\$' +
      rawString.substring(0, (rawString.length - 2)) +
      '.' +
      rawString.substring(rawString.length - 2);
  return dollarString;
}

String _numberStringToPhoneNumber(String phone) {
  if (phone == null) {
    return null;
  }
  String ps = phone.padRight(10, '_');
  String formatted = '(' +
      ps.substring(0, 3) +
      ') ' +
      ps.substring(3, 6) +
      '-' +
      ps.substring(6);
  return formatted;
}

String _pinToObfuscated(String pin) {
  if (pin == null) {
    return null;
  }
  return List.generate(pin.length, (index) => '*').join().padRight(4, '-');
}
