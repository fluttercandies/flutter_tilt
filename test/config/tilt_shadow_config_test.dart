import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_shadow_config.dart';
import 'package:flutter_tilt/src/enums.dart';

void main() {
  group('ShadowConfig ::', () {
    test('assert', () {
      expect(
        () => ShadowBaseConfig(minIntensity: 1.0, maxIntensity: 0.0),
        throwsAssertionError,
      );
      expect(
        () => ShadowBaseConfig(minIntensity: -0.1, maxIntensity: 1.0),
        throwsAssertionError,
      );
      expect(
        () => ShadowBaseConfig(minIntensity: 0.1, maxIntensity: 1.1),
        throwsAssertionError,
      );
      expect(
        () => ShadowBaseConfig(offsetFactor: -0.1),
        throwsAssertionError,
      );
    });
  });

  group('ShadowBaseConfig ::', () {
    test('assert', () {
      expect(
        () => ShadowBaseConfig(spreadFactor: -0.1),
        throwsAssertionError,
      );
      expect(
        () => ShadowBaseConfig(minBlurRadius: 0.2, maxBlurRadius: 0.1),
        throwsAssertionError,
      );
      expect(
        () => ShadowBaseConfig(minBlurRadius: -0.1, maxBlurRadius: 1.0),
        throwsAssertionError,
      );
    });

    test('copyWith', () {
      const shadowConfig = ShadowBaseConfig();
      const shadowConfigExpect = ShadowBaseConfig(
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
      final shadowConfigCopyWith = shadowConfig.copyWith(
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

    test('copyWith - direction can be explicitly set to null', () {
      const shadowConfig = ShadowBaseConfig(direction: ShadowDirection.all);
      expect(shadowConfig.copyWith().direction, ShadowDirection.all);
      expect(shadowConfig.copyWith(direction: null).direction, isNull);
    });

    test('copyWith - enableReverse can be explicitly set to null', () {
      const shadowConfig = ShadowBaseConfig(enableReverse: true);
      expect(shadowConfig.copyWith().enableReverse, true);
      expect(shadowConfig.copyWith(enableReverse: null).enableReverse, isNull);
    });

    test('hashCode', () {
      final shadowConfig = const ShadowBaseConfig();
      final shadowConfig2 = const ShadowBaseConfig();
      expect(shadowConfig == shadowConfig2, true);
      expect(shadowConfig, shadowConfig2);
      expect(shadowConfig.hashCode, shadowConfig2.hashCode);
    });
  });

  group('ShadowProjectorConfig ::', () {
    test('assert', () {
      expect(
        () => ShadowProjectorConfig(
          projectorScaleFrom: -0.1,
          projectorScaleTo: -0.1,
        ),
        throwsAssertionError,
      );
      expect(
        () => ShadowProjectorConfig(
          projectorBlurSigmaFrom: -0.1,
          projectorBlurSigmaTo: -0.1,
        ),
        throwsAssertionError,
      );
    });

    test('copyWith', () {
      const shadowConfig = ShadowProjectorConfig();
      const shadowConfigExpect = ShadowProjectorConfig(
        disable: true,
        color: Color(0xFF9E9E90),
        minIntensity: 1.0,
        maxIntensity: 1.0,
        offsetInitial: Offset(3.0, 3.0),
        offsetFactor: 4.0,
        projectorScaleFrom: 2.0,
        projectorScaleTo: 2.0,
        projectorBlurSigmaFrom: 2.0,
        projectorBlurSigmaTo: 2.0,
        direction: ShadowDirection.all,
        enableReverse: true,
      );
      final shadowConfigCopyWith = shadowConfig.copyWith(
        disable: true,
        color: const Color(0xFF9E9E90),
        minIntensity: 1.0,
        maxIntensity: 1.0,
        offsetInitial: const Offset(3.0, 3.0),
        offsetFactor: 4.0,
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

    test('copyWith - direction can be explicitly set to null', () {
      const shadowConfig =
          ShadowProjectorConfig(direction: ShadowDirection.all);
      expect(shadowConfig.copyWith().direction, ShadowDirection.all);
      expect(shadowConfig.copyWith(direction: null).direction, isNull);
    });

    test('copyWith - enableReverse can be explicitly set to null', () {
      const shadowConfig = ShadowProjectorConfig(enableReverse: true);
      expect(shadowConfig.copyWith().enableReverse, true);
      expect(shadowConfig.copyWith(enableReverse: null).enableReverse, isNull);
    });

    test('hashCode', () {
      final shadowConfig = const ShadowProjectorConfig();
      final shadowConfig2 = const ShadowProjectorConfig();
      expect(shadowConfig == shadowConfig2, true);
      expect(shadowConfig, shadowConfig2);
      expect(shadowConfig.hashCode, shadowConfig2.hashCode);
    });
  });
}
