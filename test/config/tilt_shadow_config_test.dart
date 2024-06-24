import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_shadow_config.dart';
import 'package:flutter_tilt/src/enums.dart';

void main() {
  group('ShadowConfig', () {
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
      expect(
        () => ShadowConfig(
          projectorScaleFrom: -0.1,
          projectorScaleTo: -0.1,
        ),
        throwsAssertionError,
      );
      expect(
        () => ShadowConfig(
          projectorBlurSigmaFrom: -0.1,
          projectorBlurSigmaTo: -0.1,
        ),
        throwsAssertionError,
      );
    });
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
        projectorScaleFrom: 2.0,
        projectorScaleTo: 2.0,
        projectorBlurSigmaFrom: 2.0,
        projectorBlurSigmaTo: 2.0,
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
        projectorScaleFrom: 2.0,
        projectorScaleTo: 2.0,
        projectorBlurSigmaFrom: 2.0,
        projectorBlurSigmaTo: 2.0,
        direction: ShadowDirection.all,
        enableReverse: true,
      );
      expect(shadowConfig, shadowConfig.copyWith());
      expect(shadowConfigCopyWith, shadowConfigExpect);
      expect(shadowConfigCopyWith.hashCode, shadowConfigExpect.hashCode);
    });
  });
}
