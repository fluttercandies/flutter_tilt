import 'package:flutter/material.dart';

import 'package:flutter_tilt/flutter_tilt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tilt Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const TiltDemo(),
    );
  }
}

class TiltDemo extends StatelessWidget {
  const TiltDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        /// Tilt Demo
        child: Tilt(
          borderRadius: BorderRadius.circular(24),
          tiltConfig: const TiltConfig(angle: 15),
          lightConfig: const LightConfig(
            minIntensity: 0.1,
            maxIntensity: 0.3,
          ),
          shadowConfig: const ShadowConfig(
            minIntensity: 0.05,
            maxIntensity: 0.3,
            spreadOrigin: -10,
            minBlurRadius: 10,
            maxBlurRadius: 20,
          ),
          child: const SizedBox(
            width: 250,
            height: 400,
            child: MyHomePage(title: 'Flutter Tilt Demo'),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x20777777),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
