# example

A simple example implementation of flutter_numpad_widget.


```dart
import 'package:flutter/material.dart';
import 'package:flutter_numpad_widget/flutter_numpad_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numpad Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FormattedNumpadExample(),
    );
  }
}

class FormattedNumpadExample extends StatelessWidget {
  final NumpadController _numpadController =
      NumpadController(format: NumpadFormat.PHONE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Numpad Example'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NumpadText(
                style: TextStyle(fontSize: 40),
                controller: _numpadController,
              ),
            ),
            Expanded(
              child: Numpad(
                controller: _numpadController,
                buttonTextSize: 40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
```