# flutter_numpad_widget

A set of Flutter widgets providing numpad input functionality without the soft keyboard.



## Getting Started

In your Flutter project add the dependency:

```
dependencies:
    ...
    flutter_numpad_widget: 0.0.1
```

## Usage Example
Import ```flutter_numpad_widget```
```
import 'package:flutter_numpad_widget/flutter_numpad_widget.dart'
```
### Formatted Phone Input

The simplest implementation involves creating a ```NumpadController``` and passing it to a ```Numpad``` and a ```NumpadText```.

```dart
class ExampleNumpadWidget extends StatelessWidget {

//Instantiate a NumpadController
final _controller = NumpadController(format: NumpadFormat.PHONE);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const Edgeinsets.all(16),
            child:NumpadText(
              controller: _controller,
              style: TextStyle(fontSize: 40)
            )
          ),
          Expanded(
            child: Numpad(
              controller: _controller,
              buttonTextSize: 40
            )
          )
        ]
      )
    );
  }
}
```
This will display a Numpad with a masked TextField above it showing the phone number the user has typed in.

### Other uses

It is also possible to use the Numpad on its own, and respond to user input by attaching a listener to the NumpadController.

```dart
class NumpadOnlyExample extends StatelessWidget {
  final _controller = NumpadController();

  NumpadOnlyExample() {
    this._controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    //Do things with the data in the controller.
  }

  @override
  Widget build() {
    return Numpad(controller: _controller);
  }
}
```
The NumpadController exposes a ```rawString```, ```rawNumber```, and ```formattedString``` as members.


## Feature Overview
- Optional hint text
- Styleable text field and Numpad buttons
- Automatic formatting of phone numbers, currency, and masked PINs.

For more information, see the documentation. 