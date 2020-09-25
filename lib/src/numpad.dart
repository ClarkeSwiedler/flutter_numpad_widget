import 'package:flutter/material.dart';
import 'dart:developer';

import 'numpad_controller.dart';

///A grid of evenly spaced buttons with the numbers 0 through 9, as well as
///back and clear buttons.
///
/// Requires a [NumpadController], which is responsible for parsing and storing
/// this input from this widget.
class Numpad extends StatelessWidget {
  ///Space between buttons on the numpad grid.
  final double innerPadding;

  ///Size of the text on the buttons in the numpad grid.
  final double buttonTextSize;
  final Color buttonColor;
  final Color textColor;
  final double height;
  final double width;
  final NumpadController controller;
  final Function customButton;
  Numpad({
    Key key,
    @required this.controller,
    this.customButton,
    this.buttonColor,
    this.textColor,
    this.innerPadding = 4,
    this.buttonTextSize = 30,
    this.height = double.infinity,
    this.width = double.infinity,
  }) : super(key: key);

  EdgeInsetsGeometry _buttonPadding() {
    return EdgeInsets.all(innerPadding);
  }

  Widget _buildNumButton({BuildContext context, int displayNum, Icon icon}) {
    String buttonString = displayNum.toString();
    Widget effectiveChild;
    int passNum = displayNum;
    if (icon != null) {
      effectiveChild = icon;

      /// button text to be displayed based on the icons provided.
      /// if customButton is not null.
      icon.icon.codePoint == 57676 ? buttonString = "X" : buttonString = "<-";
    } else {
      effectiveChild = Text(
        displayNum.toString(),
        style: TextStyle(fontSize: buttonTextSize, color: textColor),
      );
    }
    return Expanded(
      child: getButton(buttonString, effectiveChild, buttonColor, passNum),
    );
  }

  /// function to provide the button based on customButton() provided.
  Widget getButton(String buttonString, Widget effectiveChild,
      Color buttonColor, int passNum) {
    Widget button;
    if (customButton == null) {
      button = Container(
        padding: _buttonPadding(),
        child: RaisedButton(
          child: effectiveChild,
          color: buttonColor,
          onPressed: () => controller.parseInput(passNum),
        ),
      );
    } else {
      button = MaterialButton(
        padding: _buttonPadding(),
        onPressed: () => controller.parseInput(passNum),
        child: customButton(buttonString),
      );
    }
    return button;
  }

  Widget _buildNumRow(BuildContext context, List<int> numbers) {
    List<Widget> buttonList = numbers
        .map((buttonNum) =>
            _buildNumButton(context: context, displayNum: buttonNum))
        .toList();
    return Container(
      child: Expanded(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buttonList),
      ),
    );
  }

  Widget _buildSpecialRow(BuildContext context) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildNumButton(
                context: context,
                displayNum: -1,
                icon: Icon(
                  Icons.backspace,
                  size: buttonTextSize,
                )),
            _buildNumButton(context: context, displayNum: 0),
            _buildNumButton(
                context: context,
                displayNum: -2,
                icon: Icon(
                  Icons.clear,
                  size: buttonTextSize,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildNumPad(BuildContext context, BoxConstraints constraints) {
    return Container(
      height: height,
      width: width,
      padding: _buttonPadding(),
      child: LimitedBox(
        maxHeight: 500,
        maxWidth: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildNumRow(context, [1, 2, 3]),
            _buildNumRow(context, [4, 5, 6]),
            _buildNumRow(context, [7, 8, 9]),
            _buildSpecialRow(context)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: _buildNumPad,
    );
  }
}
