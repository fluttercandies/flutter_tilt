import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_config.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/internal/mixin/tilt_tween_animation_mixin.dart';
import 'package:flutter_tilt/src/internal/provider/tilt_provider.dart';
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
        tiltTweenAnimationDuration(false, false, GesturesType.none, tiltConfig),
        Duration.zero,
      );
      expect(
        tiltTweenAnimationDuration(true, false, GesturesType.none, tiltConfig),
        Duration.zero,
      );
      expect(
        tiltTweenAnimationDuration(
          false,
          false,
          GesturesType.touch,
          tiltConfig,
        ),
        tiltConfig.leaveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, false, GesturesType.touch, tiltConfig),
        tiltConfig.moveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, true, GesturesType.touch, tiltConfig),
        tiltConfig.enterDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          true,
          true,
          GesturesType.touch,
          tiltConfig.copyWith(enterToMoveDuration: Duration.zero),
        ),
        tiltConfig.moveDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          true,
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
        tiltTweenAnimationDuration(false, true, GesturesType.hover, tiltConfig),
        tiltConfig.leaveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, true, GesturesType.hover, tiltConfig),
        tiltConfig.enterDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          true,
          true,
          GesturesType.hover,
          tiltConfig.copyWith(enterToMoveDuration: Duration.zero),
        ),
        tiltConfig.moveDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          true,
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
        tiltTweenAnimationDuration(
          false,
          true,
          GesturesType.controller,
          tiltConfig,
        ),
        tiltConfig.controllerLeaveDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          true,
          true,
          GesturesType.controller,
          tiltConfig,
        ),
        tiltConfig.controllerMoveDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          false,
          true,
          GesturesType.sensors,
          tiltConfig,
        ),
        tiltConfig.sensorMoveDuration,
      );
      expect(
        tiltTweenAnimationDuration(
          true,
          true,
          GesturesType.sensors,
          tiltConfig,
        ),
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

    testWidgets(
      'enterToMove keeps ramping the tilt duration while the pointer stays still',
      (WidgetTester tester) async {
        const config = TiltConfig(
          enableGestureSensors: false,
          enterDuration: Duration(milliseconds: 900),
          moveDuration: Duration(milliseconds: 90),
          enterToMoveDuration: Duration(milliseconds: 300),
          enterToMoveCurve: Curves.linear,
        );
        const idle = TiltState(
          tiltConfig: config,
          isInit: true,
          width: 10.0,
          height: 10.0,
          areaProgress: Offset.zero,
          isActive: false,
          currentGesturesType: GesturesType.none,
        );

        /// enter 到角落后指针保持不动（目标固定为 (1, 1)）
        const entered = TiltState(
          tiltConfig: config,
          isInit: true,
          width: 10.0,
          height: 10.0,
          areaProgress: Offset(1.0, 1.0),
          isActive: true,
          currentGesturesType: GesturesType.touch,
        );

        final notifier = ValueNotifier<TiltState>(idle);
        addTearDown(notifier.dispose);

        await tester.pumpWidget(_TiltStateHarness(notifier: notifier));
        final state = tester.state<TiltTweenAnimationMixinTestState>(
          find.byType(TiltTweenAnimationMixinTest),
        );

        /// 触发 enter+move，开启 enterToMove 过渡
        notifier.value = entered;
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 30));
        final d1 = state.tiltTweenAnimationController.duration!;

        /// 指针保持不动，仅推进 enterToMove 过渡窗口
        await tester.pump(const Duration(milliseconds: 150));
        final d2 = state.tiltTweenAnimationController.duration!;

        expect(
          d2,
          lessThan(d1),
          reason: 'enterToMove must keep ramping the tilt animation duration '
              'from enterDuration toward moveDuration even when the pointer stays still. '
              'If d2 == d1, the per-tick duration refresh was short-circuited.',
        );

        await tester.pumpAndSettle();
      },
    );
  });
}

/// 驱动 [TiltProvider] 数据的测试
class _TiltStateHarness extends StatelessWidget {
  const _TiltStateHarness({required this.notifier});

  final ValueNotifier<TiltState> notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TiltState>(
      valueListenable: notifier,
      builder: (context, state, _) => TiltProvider(
        data: state,
        child: const TiltTweenAnimationMixinTest(),
      ),
    );
  }
}

/// TiltTweenAnimationMixin Test Widget
class TiltTweenAnimationMixinTestWidget extends StatelessWidget {
  const TiltTweenAnimationMixinTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const TiltProvider(
      data: TiltState(
        tiltConfig: TiltConfig(),
        isInit: true,
        width: 10.0,
        height: 10.0,
        areaProgress: Offset.zero,
        isActive: true,
        currentGesturesType: GesturesType.touch,
      ),
      child: TiltTweenAnimationMixinTest(),
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
