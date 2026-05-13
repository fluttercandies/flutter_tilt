# Flutter Tilt Example

🎁 Check out the [Live Demo][].  

## Example

[example/lib/main.dart](https://github.com/fluttercandies/flutter_tilt/blob/main/example/lib/main.dart)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tilt Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
          titleTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: const TiltExample(),
    );
  }
}

class TiltExample extends StatelessWidget {
  const TiltExample({super.key});

  @override
  Widget build(BuildContext context) {
    final innerBox = <Widget>[];
    for (var i = 1; i <= 10; i++) {
      innerBox.add(
        TiltParallax(
          offset: Offset(-20.0 * i, -30.0 * i),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 4 * (1 - i * 0.05),
                color: Colors.white.withValues(alpha: 1 - (i - 1) * 0.1),
              ),
            ),
            child: SizedBox(
              width: 200 * (1 - i * 0.05),
              height: 200 * (1 - i * 0.05),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Tilt(
          tiltConfig: const TiltConfig(
            angle: 20,
            leaveCurve: Curves.easeInOutCubicEmphasized,
            leaveDuration: Duration(milliseconds: 1200),
          ),
          child: TiltBaseContainer(
            lightConfig: const LightConfig(disable: true),
            shadowConfig: const ShadowBaseConfig(disable: true),
            borderRadius: BorderRadius.circular(24.0),
            childLayout: ChildLayout(
              inner: [
                ...innerBox,
                const Positioned(
                  left: 30.0,
                  top: 30.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flutter Tilt',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      Text(
                        'Layout',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  left: 30.0,
                  bottom: 30.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Touch and move around.',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Colors.black),
              child: SizedBox(width: 300, height: 500),
            ),
          ),
        ),
      ),
    );
  }
}
```

[Live Demo]: https://amoshuke.github.io/flutter_tilt_book
