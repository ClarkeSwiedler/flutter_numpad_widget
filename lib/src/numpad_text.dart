import 'package:flutter/material.dart';

import 'numpad_controller.dart';

///Wraps a [Text] widget and automatically listens and reacts to
///changes in a [NumpadController].
///
///Also provides an optional error animation that can be initiated by the
///[NumpadController].
///
///The simplest way to use this widget is just to call it and pass in a
///[NumpadController] that is associated with a [Numpad]. It is recommended
///that you also supply a TextStyle with a monospaced font (for smoother masked
///formatting), and a desired fontSize.
///
/// ```dart
/// final NumpadController _controller;
///
/// ...
///
/// Widget _buildNumpadText(context) {
///   return NumpadText(
///     controller:  _controller,
///     style: TextStyle(fontFamily: 'RobotoMono', fontSize: 40),
///   );
/// }
/// ```
class NumpadText extends StatefulWidget {

  ///The [NumpadController] this NumpadText shares with its parent Numpad.
  final NumpadController controller;

  ///The style adopted by the Text portion of this widget.
  final TextStyle style;
  final TextAlign textAlign;

  ///If true, the text will turn red, play a shaking animation, and clear itself
  ///when [NumpadController.notifyErrorResetListener] is called on the
  ///[NumpadController] associated with this [NumpadText].
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

  ///The text being currently displayed by this widget.
  String displayedText;

  ///Text will be [Colors.red] when this is true.
  bool isInvalid = false;

  NumpadController _controller;
  AnimationController _errorAnimator;
  Animation _errorAnimation;

  ///Keeps track of the number of times the [_errorAnimator] has cycled.
  var errorShakes = 0;

  ///Total number of times the text should wiggle back and forth on error.
  final totalErrorShakes = 3;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    displayedText = _controller.formattedString;
    _controller.addListener(_listener);
    _controller.setErrorResetListener(_handleError);

    _errorAnimator = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    _errorAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.2, 0))
            .animate(_errorAnimator);

    _errorAnimator.addStatusListener(_errorAnimationStatusListener);
  }

  void _listener() {
    setState(() {
      displayedText = _controller.formattedString;
    });
  }

  void _handleError() {
    setState(() {
      isInvalid = true;
    });
    _errorAnimator.forward();
  }

  void _errorAnimationStatusListener(AnimationStatus status) {
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
  }

  TextStyle _getTextStyle() {
    TextStyle style = TextStyle(
        fontFamily: 'RobotoMono', color: isInvalid ? Colors.red : null);
    return widget.style?.merge(style);
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
    _controller.removeListener(_listener);
    super.dispose();
  }
}
