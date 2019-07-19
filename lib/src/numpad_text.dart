import 'package:flutter/material.dart';

import 'numpad_controller.dart';

class NumpadText extends StatefulWidget {
  ///The NumpadController this NumpadText shares with it's parent Numpad.
  final NumpadController controller;
  ///The style adopted by the Text portion of this widget.
  final TextStyle style;
  final TextAlign textAlign;

  ///Determines whether or not the text will animated red shaking and clear itself when the controller is in an error state.
  final bool animateError;

  NumpadText({
    @required this.controller,
    this.style,
    this.textAlign = TextAlign.center,
    this.animateError = false,
  });

  @override
  _NumpadTextState createState() => _NumpadTextState();
}

class _NumpadTextState extends State<NumpadText>
    with SingleTickerProviderStateMixin {
  NumpadController _controller;
  String displayedText;

  AnimationController _errorAnimator;
  Animation _errorAnimation;

  bool isInvalid = false;

  var errorShakes = 0;
  final totalErrorShakes = 3;

  void listener() {
    setState(() {
      displayedText = _controller.formattedString;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    displayedText = _controller.formattedString;
    _controller.addListener(listener);
    _controller.setErrorResetListener(_handleError);

    _errorAnimator = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    _errorAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.2, 0))
            .animate(_errorAnimator);

    _errorAnimator.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _errorAnimator.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        errorShakes += 1;
        if (errorShakes < totalErrorShakes) {
          _errorAnimator.forward();
        } else {
          errorShakes = 0;
          isInvalid = false;
          _controller.clear();
        }
      }
    });
  }

  void _handleError() {
    setState(() {
      isInvalid = true;
    });
    _errorAnimator.forward();
  }

  TextStyle _getTextStyle() {
    TextStyle style = TextStyle(
        fontFamily: 'RobotoMono', color: isInvalid ? Colors.red : null);
//    return widget.style?.merge(style);
  return style;
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _errorAnimation,
      child: Text(
        displayedText,
        style: _getTextStyle(),
        textAlign: widget.textAlign,
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }
}
