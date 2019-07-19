import 'package:flutter/material.dart';
import 'package:flutter_numpad_widget/flutter_numpad_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FormattedNumpadExample(),
    );
  }
}

class FormattedNumpadExample extends StatefulWidget {
  @override
  _FormattedNumpadExampleState createState() => _FormattedNumpadExampleState();
}

class _FormattedNumpadExampleState extends State<FormattedNumpadExample> {
  NumpadController _numpadController =
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
            NumpadText(
              style: TextStyle(fontSize: 40),
              controller: _numpadController,
            ),
            Expanded(
              child: Numpad(
                controller: _numpadController,
                buttonTextSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
