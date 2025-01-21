import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _counter = 30.0;
  var myFontSize = 30.0;

  void setNewValue(double newValue) {
    setState(() {
      _counter = newValue.roundToDouble();
      myFontSize = newValue.roundToDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Flutter Lab')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Counter: $_counter',
            style: TextStyle(fontSize: myFontSize),
          ),
          Text(
            'Font Size: $myFontSize',
            style: TextStyle(fontSize: myFontSize),
          ),
          Slider(
            value: _counter,
            min: 0.0,
            max: 100.0,
            divisions: 100,
            label: _counter.toString(),
            onChanged: (value) {
              setNewValue(value);
            },
          ),
        ],
      ),
    );
  }
}
