import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/config/tilt_light_config.dart';

void main() {
  group('LightConfig', () {
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
      expect(
        () => LightConfig(spreadFactor: 0.1),
        throwsAssertionError,
      );
    });
    test('copyWith', () {
      const LightConfig lightConfig = LightConfig();
      const LightConfig lightConfigExpect = LightConfig(
        disable: true,
        color: Color(0xFFFFFFF0),
        minIntensity: 0.0,
        maxIntensity: 0.5,
        spreadFactor: 1.0,
        direction: LightDirection.around,
        enableReverse: true,
      );
      final LightConfig lightConfigCopyWith = lightConfig.copyWith(
        disable: true,
        color: const Color(0xFFFFFFF0),
        minIntensity: 0.0,
        maxIntensity: 0.5,
        spreadFactor: 1.0,
        direction: LightDirection.around,
        enableReverse: true,
      );
      expect(lightConfig, lightConfig.copyWith());
      expect(lightConfigCopyWith, lightConfigExpect);
      expect(lightConfigCopyWith.hashCode, lightConfigExpect.hashCode);
    });
  });
}
