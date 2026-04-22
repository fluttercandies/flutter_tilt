import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

void main() {
  group('TiltAnimatedBuilder ::', () {
    testWidgets('basic build and child usage', (WidgetTester tester) async {
      const initialProgress = Offset(1.0, 1.0);
      Size? reportedSize;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Tilt(
              tiltConfig: const TiltConfig(initial: initialProgress),
              child: SizedBox(
                width: 100,
                height: 100,
                child: TiltAnimatedBuilder(
                  builder: (context, animatedState, child) {
                    final tiltConfig = animatedState.tiltConfig;
                    final targetTiltData = animatedState.targetTiltData;
                    final animatedTiltData = animatedState.animatedTiltData;
                    final currentGesturesType =
                        animatedState.currentGesturesType;

                    reportedSize = Size(
                      animatedTiltData.width,
                      animatedTiltData.height,
                    );

                    /// 检查 builder 数据是否可用
                    expect(tiltConfig, isNotNull);
                    expect(targetTiltData, isNotNull);
                    expect(animatedTiltData, isNotNull);
                    expect(targetTiltData.areaProgress, initialProgress);
                    expect(animatedTiltData.areaProgress, initialProgress);
                    expect(currentGesturesType, GesturesType.none);

                    /// 渲染 child
                    return Column(
                      children: [
                        Expanded(
                          child: Text(
                            'progress: ${animatedTiltData.areaProgress}',
                          ),
                        ),
                        if (child != null) child,
                      ],
                    );
                  },
                  child: const Text('static child'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      /// 检查静态 child 是否渲染
      expect(find.text('static child'), findsOneWidget);

      /// 检查 builder 渲染内容
      expect(find.byType(Column), findsOneWidget);
      expect(find.textContaining('progress: $initialProgress'), findsOneWidget);

      /// 检查尺寸回调是否正确
      expect(reportedSize, const Size(100, 100));
    });

    testWidgets('uses animated progress during hover move', (
      WidgetTester tester,
    ) async {
      var latestTargetAreaProgress = Offset.zero;
      var latestAnimatedAreaProgress = Offset.zero;
      final testPointer = TestPointer(1, PointerDeviceKind.mouse);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Tilt(
                key: const Key('tilt_widget'),
                tiltConfig: const TiltConfig(
                  enableGestureSensors: false,
                  enterDuration: Duration(milliseconds: 100),
                  moveDuration: Duration(milliseconds: 100),
                  enterToMoveDuration: Duration.zero,
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: TiltAnimatedBuilder(
                    builder: (context, animatedState, child) {
                      final targetTiltData = animatedState.targetTiltData;
                      final animatedTiltData = animatedState.animatedTiltData;

                      latestTargetAreaProgress = targetTiltData.areaProgress;
                      latestAnimatedAreaProgress =
                          animatedTiltData.areaProgress;
                      return child ?? const SizedBox();
                    },
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
      final hoverEventLocation = tester.getCenter(tiltWidgetFinder);

      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-25.0, -25.0)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final intermediateTargetAreaProgress = latestTargetAreaProgress;
      final intermediateAnimatedAreaProgress = latestAnimatedAreaProgress;

      await tester.pumpAndSettle();

      final finalTargetAreaProgress = latestTargetAreaProgress;
      final finalAnimatedAreaProgress = latestAnimatedAreaProgress;

      expect(intermediateTargetAreaProgress, isNot(Offset.zero));
      expect(intermediateTargetAreaProgress, finalTargetAreaProgress);
      expect(intermediateAnimatedAreaProgress, isNot(Offset.zero));
      expect(
        intermediateAnimatedAreaProgress,
        isNot(finalAnimatedAreaProgress),
      );
      expect(
        intermediateAnimatedAreaProgress.dx.abs(),
        lessThan(finalAnimatedAreaProgress.dx.abs()),
      );
      expect(
        intermediateAnimatedAreaProgress.dy.abs(),
        lessThan(finalAnimatedAreaProgress.dy.abs()),
      );
      expect(finalTargetAreaProgress, finalAnimatedAreaProgress);

      await tester.sendEventToBinding(testPointer.removePointer());
    });
  });
}
