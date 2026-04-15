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
                  builder: (context, tiltData, tiltConfig, child) {
                    reportedSize = Size(tiltData.width, tiltData.height);

                    /// 检查 builder 数据是否可用
                    expect(tiltData, isNotNull);
                    expect(tiltData.areaProgress, initialProgress);
                    expect(tiltConfig, isNotNull);

                    /// 渲染 child
                    return Column(
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
  });
}
