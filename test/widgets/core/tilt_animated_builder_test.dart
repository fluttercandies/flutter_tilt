import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

void main() {
  group('TiltAnimatedBuilder ::', () {
    testWidgets('basic build and child usage', (WidgetTester tester) async {
      const initialProgress = Offset(1.0, 1.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Tilt(
              tiltConfig: const TiltConfig(initial: initialProgress),
              child: TiltAnimatedBuilder(
                builder: (context, tiltData, tiltConfig, onResize, child) {
                  /// 检查 builder 数据是否可用
                  expect(tiltData, isNotNull);
                  expect(tiltData.areaProgress, initialProgress);
                  expect(tiltConfig, isNotNull);
                  expect(onResize, isA<Function>());

                  /// 渲染 child
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text('progress: ${tiltData.areaProgress}'),
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
      );

      await tester.pumpAndSettle();

      /// 检查静态 child 是否渲染
      expect(find.text('static child'), findsOneWidget);

      /// 检查 builder 渲染内容
      expect(find.byType(Column), findsOneWidget);
      expect(find.textContaining('progress: $initialProgress'), findsOneWidget);
    });

    testWidgets('onResize receives new size', (WidgetTester tester) async {
      Size? receivedSize;
      late void Function(Size) onResizeRef;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Tilt(
              child: TiltAnimatedBuilder(
                builder: (context, tiltData, tiltConfig, onResize, child) {
                  onResizeRef = onResize;
                  receivedSize = Size(tiltData.width, tiltData.height);

                  return Stack(
                    children: [
                      child!,

                      /// 使用 LayoutBuilder 监听尺寸变化，并调用 onResize
                      Positioned.fill(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (context.mounted) {
                                onResize(constraints.biggest);
                              }
                            });
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  );
                },
                child: const SizedBox(width: 10, height: 10),
              ),
            ),
          ),
        ),
      );

      /// 初始尺寸应该是 child 的尺寸
      await tester.pumpAndSettle();
      expect(receivedSize, const Size(10, 10));

      /// 调用 onResize 更新尺寸
      const testSize = Size(123, 456);
      onResizeRef(testSize);

      /// 等待 1 帧以确保 onResize 被处理
      await tester.pump();
      expect(receivedSize, testSize);

      /// 再等待 1 帧将尺寸还原为 LayoutBuilder 监听的尺寸
      await tester.pump();
      expect(receivedSize, const Size(10, 10));
    });
  });
}
