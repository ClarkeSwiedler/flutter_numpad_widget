import 'package:flutter/foundation.dart';

import 'formatting/formatter.dart';

typedef ValidInputCallback = void Function(bool);

class NumpadController with ChangeNotifier {
  final NumpadFormat format;

  int rawNumber;
  String rawString;
  String hintText;

  String _formattedString;

  set formattedString(String value) {
    _formattedString = value ?? hintText ?? defaultHintText;
    notifyListeners();
  }

  get formattedString => _formattedString;

  bool inputValid;
  ValidInputCallback onInputValidChange;
  VoidCallback onErrorResetRequest;

  void notifyErrorResetListener() {
    onErrorResetRequest?.call();
  }

  void setErrorResetListener(VoidCallback listener) {
    this.onErrorResetRequest = listener;
  }

  int maxRawLength;
  String defaultHintText;

  NumpadController(
      {this.format = NumpadFormat.NONE, this.hintText, this.onInputValidChange}) {
    switch (format) {
      case NumpadFormat.NONE:
        defaultHintText = 'Enter Number';
        maxRawLength = 10;
        break;
      case NumpadFormat.CURRENCY:
        defaultHintText = '\$0.00';
        maxRawLength = 6;
        break;
      case NumpadFormat.PHONE:
        defaultHintText = '(___) ___-____';
        maxRawLength = 10;
        break;
      case NumpadFormat.PIN4:
        defaultHintText = '----';
        maxRawLength = 4;
        break;
    }
    _formattedString = hintText ?? defaultHintText;
  }



  void parseInput(int input) {
    switch (input) {
      case -2: //Clear
        rawString = null;
        if (inputValid == true) {
          inputValid = false;
          onInputValidChange?.call(inputValid);
        }
        break;
      case -1: //Backspace
        if (rawString != null && rawString.length > 1) {
          rawString = rawString.substring(0, rawString.length - 1);
        } else {
          rawString = null;
        }
        if (inputValid == true) {
          inputValid = false;
          onInputValidChange?.call(inputValid);
        }
        break;
      default:
        if (rawString != null) {
          if (rawString.length < maxRawLength) {
            rawString += input.toString();
            if (rawString.length == maxRawLength &&
                format != NumpadFormat.CURRENCY) {
              inputValid = true;
              onInputValidChange?.call(inputValid);
            }
          }
        } else {
          if (input == 0 && format == NumpadFormat.CURRENCY) {
            break;
          }
          rawString = input.toString();
          if (format == NumpadFormat.CURRENCY) {
            inputValid = true;
            onInputValidChange?.call(inputValid);
          }
        }
        break;
    }
    if (rawString == null) {
      rawNumber = null;
      formattedString = null;
    } else {
      rawNumber = num.tryParse(rawString);
      formattedString = formatRawString(rawString, format);
    }
  }

  void clear() {
    rawNumber = null;
    rawString = null;
    _formattedString = hintText ?? defaultHintText;
    notifyListeners();
  }
}
