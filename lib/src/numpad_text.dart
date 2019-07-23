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
  ///when [NumpadController.notifyErrorResetListener] is called on [controller].
  final bool animateError;

  ///The color to apply to the text when the error animation is playing.
  final Color errorColor;

  NumpadText({
    @required this.controller,
    this.style,
    this.textAlign = TextAlign.center,
    this.animateError = false,
    this.errorColor = Colors.red,
  });

  @override
  _NumpadTextState createState() => _NumpadTextState();
}

class _NumpadTextState extends State<NumpadText>
    with SingleTickerProviderStateMixin {
  ///The text being currently displayed by this widget.
  String displayedText;

  NumpadController _controller;

  AnimationController _errorAnimator;
  Animation _errorAnimation;
  final _totalErrorShakes = 3;
  var _errorShakes = 0;
  bool _isErrorColor = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller
      ..addListener(_listener)
      ..setErrorResetListener(_handleError);

    displayedText = _controller.formattedString;

    _errorAnimator = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100))
      ..addStatusListener(_errorAnimationStatusListener);

    _errorAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.2, 0))
            .animate(_errorAnimator);
  }

  void _listener() {
    setState(() {
      displayedText = _controller.formattedString;
    });
  }

  void _handleError() {
    if (widget.animateError) {
      setState(() {
        _isErrorColor = true;
      });
      _errorAnimator.forward();
    } else {
      _controller.clear();
    }
  }

  void _errorAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _errorAnimator.reverse();
    }
    if (status == AnimationStatus.dismissed) {
      _errorShakes += 1;
      if (_errorShakes < _totalErrorShakes) {
        _errorAnimator.forward();
      } else {
        _errorShakes = 0;
        _isErrorColor = false;
        _controller.clear();
      }
    }
  }

  TextStyle _getTextStyle() {
    TextStyle style = TextStyle(
        fontFamily: 'RobotoMono', color: _isErrorColor ? Colors.red : null);
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
