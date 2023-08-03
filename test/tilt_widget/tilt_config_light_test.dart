import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

void main() {
  group('tilt LightConfig', () {
    test('assert', () {
      expect(
        () => LightConfig(
          minIntensity: 1.0,
          maxIntensity: 0.0,
        ),
        throwsAssertionError,
      );
      expect(
        () => LightConfig(
          minIntensity: -0.1,
          maxIntensity: 1.0,
        ),
        throwsAssertionError,
      );
      expect(
        () => LightConfig(
          minIntensity: 0.1,
          maxIntensity: 1.1,
        ),
        throwsAssertionError,
      );
    });
  });
}
