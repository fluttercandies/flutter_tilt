import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';

void main() {
  group('LightConfig', () {
    test('copyWith', () {
      const LightConfig lightConfig = LightConfig();
      const LightConfig lightConfigExpect = LightConfig(
        disable: true,
        color: Color(0xFFFFFFF0),
        minIntensity: 0.0,
        maxIntensity: 0.5,
        direction: LightDirection.around,
        enableReverse: true,
      );
      final LightConfig lightConfigCopyWith = lightConfig.copyWith(
        disable: true,
        color: const Color(0xFFFFFFF0),
        minIntensity: 0.0,
        maxIntensity: 0.5,
        direction: LightDirection.around,
        enableReverse: true,
      );
      expect(lightConfig, lightConfig.copyWith());
      expect(lightConfigCopyWith, lightConfigExpect);
      expect(lightConfigCopyWith.hashCode, lightConfigExpect.hashCode);
    });
  });
}
