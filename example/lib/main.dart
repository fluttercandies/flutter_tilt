import 'package:flutter/material.dart';

///
import 'package:flutter_tilt/flutter_tilt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tilt Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Demo(),
    );
  }
}

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Tilt(
          width: 250,
          height: 450,
          borderRadius: BorderRadius.circular(20),
          child: Scaffold(
            backgroundColor: const Color(0xFF777777),
            appBar: AppBar(title: const Text('Flutter Tilt Demo')),
            body: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Tilt(
                    width: 200,
                    height: 300,
                    borderRadius: BorderRadius.circular(20),
                    sensitivity: 1.2,
                    child: Builder(builder: (context) {
                      return Container(
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.withOpacity(0.1),
                              Colors.grey.withOpacity(0.1)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
