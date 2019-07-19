import 'package:flutter/material.dart';

import 'numpad_controller.dart';

class Numpad extends StatelessWidget {
  final double innerPadding;
  final double buttonTextSize;
  final Color buttonColor;
  final Color textColor;
  final double height;
  final double width;
  final NumpadController controller;

  Numpad({
    Key key,
    @required this.controller,
    this.buttonColor,
    this.textColor,
    this.innerPadding = 4,
    this.buttonTextSize = 30,
    this.height = double.infinity,
    this.width = double.infinity,
  }) : super(key: key);

  EdgeInsetsGeometry buttonPadding() {
    return EdgeInsets.all(innerPadding);
  }

  Widget _numButton({BuildContext context, int displayNum, Icon icon}) {
    Widget effectiveChild;
    int passNum = displayNum;
    if (icon != null) {
      effectiveChild = icon;
    } else {
      effectiveChild = Text(
        displayNum.toString(),
        style: TextStyle(
            fontSize: buttonTextSize, color: textColor ?? Colors.white),
      );
    }
    return Expanded(
      child: Container(
        padding: buttonPadding(),
        child: RaisedButton(
          child: effectiveChild,
          color: buttonColor ??
//              Theme.of(context).buttonTheme?.colorScheme ??
              Theme.of(context).buttonColor,
          onPressed: () => controller.parseInput(passNum),
//          padding: padding,
        ),
      ),
    );
  }

  Widget _buildNumRow(BuildContext context, List<int> numbers) {
    List<Widget> buttonList = numbers
        .map((buttonNum) => _numButton(context: context, displayNum: buttonNum))
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
            _numButton(
                context: context,
                displayNum: -1,
                icon: Icon(
                  Icons.backspace,
                  color: Colors.white,
                  size: buttonTextSize,
                )),
            _numButton(context: context, displayNum: 0),
            _numButton(
                context: context,
                displayNum: -2,
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
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
      padding: buttonPadding(),
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
