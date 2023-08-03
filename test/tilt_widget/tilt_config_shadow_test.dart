import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

void main() {
  group('tilt LightConfig', () {
    test('assert', () {
      expect(
        () => ShadowConfig(minIntensity: 1.0, maxIntensity: 0.0),
        throwsAssertionError,
      );
      expect(
        () => ShadowConfig(minIntensity: -0.1, maxIntensity: 1.0),
        throwsAssertionError,
      );
      expect(
        () => ShadowConfig(minIntensity: 0.1, maxIntensity: 1.1),
        throwsAssertionError,
      );
      expect(
        () => ShadowConfig(offsetFactor: -0.1),
        throwsAssertionError,
      );
      expect(
        () => ShadowConfig(spreadFactor: -0.1),
        throwsAssertionError,
      );
      expect(
        () => ShadowConfig(minBlurRadius: 0.2, maxBlurRadius: 0.1),
        throwsAssertionError,
      );
      expect(
        () => ShadowConfig(minBlurRadius: -0.1, maxBlurRadius: 1.0),
        throwsAssertionError,
      );
    });
  });
}
