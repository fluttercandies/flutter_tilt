import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_config.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/internal/mixin/tilt_tween_animation_mixin.dart';
import 'package:flutter_tilt/src/internal/tilt_state.dart';

void main() {
  group('TiltTweenAnimationMixin ::', () {
    testWidgets('tiltTweenAnimationEnd', (WidgetTester tester) async {
      await tester.pumpWidget(const TiltTweenAnimationMixinTestWidget());
      final tiltTweenAnimationTest =
          tester.state<TiltTweenAnimationMixinTestState>(
        find.byType(TiltTweenAnimationMixinTest),
      );
      final tiltTweenAnimationEnd =
          tiltTweenAnimationTest.tiltTweenAnimationEnd;
      const tiltConfig = TiltConfig();
      const areaProgress = Offset(1.0, 1.0);
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

    testWidgets('tiltTweenAnimationDuration', (WidgetTester tester) async {
      await tester.pumpWidget(const TiltTweenAnimationMixinTestWidget());
      final tiltTweenAnimationTest =
          tester.state<TiltTweenAnimationMixinTestState>(
        find.byType(TiltTweenAnimationMixinTest),
      );
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
        tiltConfig.enterDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          true,
          GesturesType.touch,
          tiltConfig.copyWith(enterToMoveDuration: Duration.zero),
        ),
        tiltConfig.moveDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          true,
          GesturesType.touch,
          tiltConfig.copyWith(
            enterDuration: const Duration(milliseconds: 2),
            moveDuration: const Duration(milliseconds: 1),
            enterToMoveDuration: const Duration(milliseconds: 1),
          ),
        ),
        const Duration(milliseconds: 2),
      );
      expect(
        tiltTweenAnimationDuration(
          true,
          GesturesType.touch,
          tiltConfig.copyWith(
            enterDuration: const Duration(milliseconds: 1),
            moveDuration: const Duration(milliseconds: 2),
            enterToMoveDuration: const Duration(milliseconds: 1),
          ),
        ),
        const Duration(milliseconds: 1),
      );
      expect(
        tiltTweenAnimationDuration(false, GesturesType.hover, tiltConfig),
        tiltConfig.leaveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, GesturesType.hover, tiltConfig),
        tiltConfig.enterDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          true,
          GesturesType.hover,
          tiltConfig.copyWith(enterToMoveDuration: Duration.zero),
        ),
        tiltConfig.moveDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          true,
          GesturesType.hover,
          tiltConfig.copyWith(
            enterDuration: const Duration(milliseconds: 2),
            moveDuration: const Duration(milliseconds: 1),
            enterToMoveDuration: const Duration(milliseconds: 1),
          ),
        ),
        const Duration(milliseconds: 2),
      );
      expect(
        tiltTweenAnimationDuration(
          true,
          GesturesType.hover,
          tiltConfig.copyWith(
            enterDuration: const Duration(milliseconds: 1),
            moveDuration: const Duration(milliseconds: 2),
            enterToMoveDuration: const Duration(milliseconds: 1),
          ),
        ),
        const Duration(milliseconds: 1),
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

    testWidgets('tiltTweenAnimationCurve', (WidgetTester tester) async {
      await tester.pumpWidget(const TiltTweenAnimationMixinTestWidget());
      final tiltTweenAnimationTest =
          tester.state<TiltTweenAnimationMixinTestState>(
        find.byType(TiltTweenAnimationMixinTest),
      );
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

/// TiltTweenAnimationMixin Test Widget
class TiltTweenAnimationMixinTestWidget extends StatelessWidget {
  const TiltTweenAnimationMixinTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TiltState(
      tiltConfig: const TiltConfig(),
      isInit: true,
      width: 10.0,
      height: 10.0,
      areaProgress: Offset.zero,
      isMove: true,
      currentGesturesType: GesturesType.touch,
      onResize: (_) {},
      child: const TiltTweenAnimationMixinTest(),
    );
  }
}

class TiltTweenAnimationMixinTest extends StatefulWidget {
  const TiltTweenAnimationMixinTest({super.key});

  @override
  State<TiltTweenAnimationMixinTest> createState() =>
      TiltTweenAnimationMixinTestState();
}

class TiltTweenAnimationMixinTestState
    extends State<TiltTweenAnimationMixinTest>
    with TickerProviderStateMixin, TiltTweenAnimationMixin {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
