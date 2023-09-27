import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/config/tilt_shadow_config.dart';

void main() {
  group('ShadowConfig', () {
    test('copyWith', () {
      const ShadowConfig shadowConfig = ShadowConfig();
      const ShadowConfig shadowConfigExpect = ShadowConfig(
        disable: true,
        color: Color(0xFF9E9E90),
        minIntensity: 1.0,
        maxIntensity: 1.0,
        offsetInitial: Offset(3.0, 3.0),
        offsetFactor: 4.0,
        spreadInitial: 5.0,
        spreadFactor: 6.0,
        minBlurRadius: 7.0,
        maxBlurRadius: 8.0,
        direction: ShadowDirection.all,
        enableReverse: true,
      );
      final ShadowConfig shadowConfigCopyWith = shadowConfig.copyWith(
        disable: true,
        color: const Color(0xFF9E9E90),
        minIntensity: 1.0,
        maxIntensity: 1.0,
        offsetInitial: const Offset(3.0, 3.0),
        offsetFactor: 4.0,
        spreadInitial: 5.0,
        spreadFactor: 6.0,
        minBlurRadius: 7.0,
        maxBlurRadius: 8.0,
        direction: ShadowDirection.all,
        enableReverse: true,
      );
      expect(shadowConfig, shadowConfig.copyWith());
      expect(shadowConfigCopyWith, shadowConfigExpect);
      expect(shadowConfigCopyWith.hashCode, shadowConfigExpect.hashCode);
    });
  });
}
