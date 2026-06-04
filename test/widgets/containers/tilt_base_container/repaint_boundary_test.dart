import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

import '../../shared_widgets/paint_counter.dart';

void main() {
  group('TiltBaseContainer :: RepaintBoundary ::', () {
    testWidgets(
      'does NOT repaint the parent subtree while the tilt animates',
      (WidgetTester tester) async {
        var outerPaintCount = 0;
        var innerPaintCount = 0;
        final tiltController = TiltController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RepaintBoundary(
                child: PaintCounter(
                  /// 边界 *外* 的计数器（位于 Tilt 之上）。
                  onPaint: () => outerPaintCount++,
                  child: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Tilt.base(
                        tiltController: tiltController,
                        tiltConfig: const TiltConfig(
                          enableGestureSensors: false,
                          controllerMoveDuration: Duration(milliseconds: 300),
                        ),
                        child: PaintCounter(
                          /// 边界 *内* 的计数器（位于倾斜 Transform 之下）。
                          onPaint: () => innerPaintCount++,
                          child: const SizedBox(width: 50, height: 50),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        /// 触发倾斜动画
        tiltController.move(
          position: const Offset(50.0, 50.0),
          gesturesType: GesturesType.controller,
        );

        /// 继续推进动画的若干帧（累计时长仍短于 controllerMoveDuration，确保动画进行中）
        const frameCount = 6;
        for (var i = 0; i < frameCount; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }

        /// 初次渲染时会调用一次 paint，之后动画过程中每帧至少调用一次
        expect(innerPaintCount, 1 + frameCount);

        /// 初次渲染时会调用一次 paint，之后动画过程中不应再增加
        expect(outerPaintCount, 1);

        await tiltController.dispose();
      },
    );
  });
}
