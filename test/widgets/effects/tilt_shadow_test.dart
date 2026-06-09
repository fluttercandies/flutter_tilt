import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_light_config.dart';
import 'package:flutter_tilt/src/config/tilt_shadow_config.dart';
import 'package:flutter_tilt/src/widgets/effects/tilt_shadow.dart';

void main() {
  /// 一个仅关心 [areaProgress] 的 [TiltShadow]，用于测试 [centerMaxProgress] 的计算逻辑
  TiltShadow shadowOf(Offset areaProgress) => TiltShadowBase(
        width: 100.0,
        height: 100.0,
        areaProgress: areaProgress,
        lightConfig: const LightConfig(),
        shadowConfig: const ShadowBaseConfig(),
        clipBehavior: Clip.none,
        child: const SizedBox(),
      );

  group('TiltShadow.centerMaxProgress ::', () {
    test('returns 0.0 at center (no tilt)', () {
      expect(shadowOf(Offset.zero).centerMaxProgress, 0.0);
    });

    test('returns 1.0 at single-axis edge', () {
      expect(shadowOf(const Offset(1.0, 0.0)).centerMaxProgress, 1.0);
      expect(shadowOf(const Offset(0.0, 1.0)).centerMaxProgress, 1.0);
      expect(shadowOf(const Offset(-1.0, 0.0)).centerMaxProgress, 1.0);
      expect(shadowOf(const Offset(0.0, -1.0)).centerMaxProgress, 1.0);
    });

    test('scales linearly with distance from center', () {
      expect(
        shadowOf(const Offset(0.6, 0.0)).centerMaxProgress,
        closeTo(0.6, 1e-10),
      );
      expect(
        shadowOf(const Offset(0.0, -0.5)).centerMaxProgress,
        closeTo(0.5, 1e-10),
      );

      /// sqrt(0.3² + 0.4²) = 0.5
      expect(
        shadowOf(const Offset(0.3, 0.4)).centerMaxProgress,
        closeTo(0.5, 1e-10),
      );
    });

    test('clamps diagonal distance to 1.0', () {
      /// 角落的 centerProgress = sqrt(2) ≈ 1.414，超过了进度上限
      for (final corner in const [
        Offset(1.0, 1.0),
        Offset(-1.0, -1.0),
        Offset(1.0, -1.0),
        Offset(-1.0, 1.0),
      ]) {
        expect(
          shadowOf(corner).centerMaxProgress,
          1.0,
          reason: 'areaProgress=$corner',
        );
      }
    });

    test('clamps raw centerProgress above 1.0', () {
      final shadow = shadowOf(const Offset(1.0, 1.0));

      expect(shadow.centerProgress, greaterThan(1.0));

      expect(shadow.centerMaxProgress, 1.0);
    });

    test('always stays within [0.0, 1.0]', () {
      for (final p in const [
        Offset.zero,
        Offset(0.25, 0.0),
        Offset(0.5, 0.5),
        Offset(1.0, 1.0),
        Offset(-1.0, -1.0),
        Offset(0.7, -0.7),
      ]) {
        expect(
          shadowOf(p).centerMaxProgress,
          inInclusiveRange(0.0, 1.0),
          reason: 'areaProgress=$p',
        );
      }
    });
  });
}
