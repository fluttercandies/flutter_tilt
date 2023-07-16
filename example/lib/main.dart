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

class CounterController extends ChangeNotifier {
  ValueNotifier<int> counter = ValueNotifier(0);
}

class TiltDemo extends StatelessWidget {
  const TiltDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterController counterController = CounterController();

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      body: Center(
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
            spreadInitial: -10,
            minBlurRadius: 10,
            maxBlurRadius: 20,
          ),
          childInner: [
            CounterText(controller: counterController),
            CounterActionButton(controller: counterController),
          ],
          child: const MyHomePage(title: 'Flutter Tilt Demo'),
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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 400,
      child: Scaffold(
        backgroundColor: const Color(0x2026262B),
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'You have pushed the button this many times:',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CounterActionButton extends StatelessWidget {
  const CounterActionButton({super.key, required this.controller});
  final CounterController controller;

  void _incrementCounter() {
    controller.counter.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: TiltParallax(
        child: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key, required this.controller});
  final CounterController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: -20,
      child: Center(
        child: TiltParallax(
          size: const Offset(-10, -10),
          child: ValueListenableBuilder(
            valueListenable: controller.counter,
            builder: (_, counter, child) {
              return Text(
                '$counter',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}
