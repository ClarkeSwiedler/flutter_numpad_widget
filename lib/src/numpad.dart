import 'package:flutter/material.dart';

import 'numpad_controller.dart';
import 'formatter.dart';

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

  Widget numButton({BuildContext context, int displayNum, Icon icon}) {
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

  Widget numRow(BuildContext context, List<int> numbers) {
    return Container(
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (var n in numbers) numButton(context: context, displayNum: n)
          ],
        ),
      ),
    );
  }

  Widget specialRow(BuildContext context) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            numButton(
                context: context,
                displayNum: -1,
                icon: Icon(
                  Icons.backspace,
                  color: Colors.white,
                  size: buttonTextSize,
                )),
            numButton(context: context, displayNum: 0),
            numButton(
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

  final logger = _NumpadLogger();

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
            numRow(context, [1, 2, 3]),
            numRow(context, [4, 5, 6]),
            numRow(context, [7, 8, 9]),
            specialRow(context)
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

class _NumpadLogger {
  bool hasLoggedBuild = false;

  printConstraints(BoxConstraints constraints) {
    if (hasLoggedBuild) return;
    print(
        'Constraints: max height = ${constraints.maxHeight}, max width = ${constraints.maxWidth}');
    hasLoggedBuild = true;
  }
}
