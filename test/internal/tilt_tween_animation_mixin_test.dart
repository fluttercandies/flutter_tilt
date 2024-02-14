import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/config/tilt_config.dart';
import 'package:flutter_tilt/src/internal/tilt_tween_animation_mixin.dart';

void main() {
  group('TiltTweenAnimation', () {
    final tiltTweenAnimationTest = TiltTweenAnimationTest();
    test('tiltTweenAnimationEnd', () {
      final tiltTweenAnimationEnd =
          tiltTweenAnimationTest.tiltTweenAnimationEnd;
      const tiltConfig = TiltConfig();
      const Offset areaProgress = Offset(1.0, 1.0);
      expect(
        tiltTweenAnimationEnd(
          false,
          tiltConfig,
          areaProgress,
        ),
        tiltConfig.initial ?? Offset.zero,
      );
      expect(
        tiltTweenAnimationEnd(
          false,
          const TiltConfig(enableRevert: false),
          areaProgress,
        ),
        areaProgress,
      );
      expect(
        tiltTweenAnimationEnd(
          false,
          const TiltConfig(initial: Offset(0.5, 0.5)),
          areaProgress,
        ),
        const Offset(0.5, 0.5),
      );
    });

    test('tiltTweenAnimationDuration', () {
      final tiltTweenAnimationDuration =
          tiltTweenAnimationTest.tiltTweenAnimationDuration;
      const tiltConfig = TiltConfig();
      expect(
        tiltTweenAnimationDuration(false, GesturesType.none, tiltConfig),
        Duration.zero,
      );
      expect(
        tiltTweenAnimationDuration(true, GesturesType.none, tiltConfig),
        Duration.zero,
      );
      expect(
        tiltTweenAnimationDuration(false, GesturesType.touch, tiltConfig),
        tiltConfig.leaveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, GesturesType.touch, tiltConfig),
        tiltConfig.moveDuration,
      );
      expect(
        tiltTweenAnimationDuration(false, GesturesType.hover, tiltConfig),
        tiltConfig.leaveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, GesturesType.hover, tiltConfig),
        tiltConfig.moveDuration,
      );
      expect(
        tiltTweenAnimationDuration(false, GesturesType.controller, tiltConfig),
        tiltConfig.controllerLeaveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, GesturesType.controller, tiltConfig),
        tiltConfig.controllerMoveDuration,
      );
      expect(
        tiltTweenAnimationDuration(false, GesturesType.sensors, tiltConfig),
        tiltConfig.sensorMoveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, GesturesType.sensors, tiltConfig),
        tiltConfig.sensorMoveDuration,
      );
    });

    test('tiltTweenAnimationCurve', () {
      final tiltTweenAnimationCurve =
          tiltTweenAnimationTest.tiltTweenAnimationCurve;
      const tiltConfig = TiltConfig();
      expect(
        tiltTweenAnimationCurve(false, GesturesType.none, tiltConfig),
        Curves.linear,
      );
      expect(
        tiltTweenAnimationCurve(true, GesturesType.none, tiltConfig),
        Curves.linear,
      );
      expect(
        tiltTweenAnimationCurve(false, GesturesType.touch, tiltConfig),
        tiltConfig.leaveCurve,
      );
      expect(
        tiltTweenAnimationCurve(true, GesturesType.touch, tiltConfig),
        tiltConfig.moveCurve,
      );
      expect(
        tiltTweenAnimationCurve(false, GesturesType.hover, tiltConfig),
        tiltConfig.leaveCurve,
      );
      expect(
        tiltTweenAnimationCurve(true, GesturesType.hover, tiltConfig),
        tiltConfig.moveCurve,
      );
      expect(
        tiltTweenAnimationCurve(false, GesturesType.controller, tiltConfig),
        Curves.linear,
      );
      expect(
        tiltTweenAnimationCurve(true, GesturesType.controller, tiltConfig),
        Curves.linear,
      );
      expect(
        tiltTweenAnimationCurve(false, GesturesType.sensors, tiltConfig),
        Curves.linear,
      );
      expect(
        tiltTweenAnimationCurve(true, GesturesType.sensors, tiltConfig),
        Curves.linear,
      );
    });
  });
}

class TiltTweenAnimationTest with TiltTweenAnimation {}
