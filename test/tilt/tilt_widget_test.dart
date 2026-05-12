import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'shared_widgets/tilt_widget.dart';

void main() {
  final tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
  final childFinder = find.text('Tilt');

  group('Tilt Widget ::', () {
    testWidgets('child rebuild count', (WidgetTester tester) async {
      const fps = 120;
      var moveCount = 0;
      var childBuildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Tilt(
              key: const Key('tilt_widget'),
              fps: fps,
              onGestureMove: (_, __) {
                moveCount++;
              },
              child: Builder(
                builder: (_) {
                  childBuildCount++;
                  return const SizedBox(
                    width: 10,
                    height: 10,
                    child: Text('Tilt'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.timedDrag(
        find.byKey(const Key('tilt_widget')),
        const Offset(0.0, 5.0),
        const Duration(milliseconds: 1000),
        frequency: fps.toDouble(),
      );
      await tester.pumpAndSettle();

      expect(moveCount, fps + 1);
      expect(childBuildCount, 1);
    });
  });

  group('Tilt config ::', () {
    testWidgets('default', (WidgetTester tester) async {
      await tester.pumpWidget(const TiltWidget());
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
    });
    testWidgets('disable true', (WidgetTester tester) async {
      final scrollController = ScrollController();

      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: scrollController,
              children: <Widget>[
                Tilt(
                  key: const Key('tilt_widget'),
                  disable: true,
                  onGestureMove: (
                    TiltDataModel tiltData,
                    GesturesType gesturesType,
                  ) {
                    tiltDataTest = tiltData;
                    gesturesTypeTest = gesturesType;
                  },
                  child: const TiltBaseContainer(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Text('Tilt'),
                    ),
                  ),
                ),
                const SizedBox(key: Key('scroll'), height: 100, width: 100),
                const SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      );

      /// onVerticalDragUpdate
      await tester.timedDrag(
        childFinder,
        const Offset(0.0, -50.0),
        const Duration(milliseconds: 1000),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(scrollController.offset, 50.0);
      expect(gesturesTypeTest, null);
      expect(tiltDataTest, null);
    });

    testWidgets('fps', (WidgetTester tester) async {
      const fpsList = <int>[120, 60, 30, 10];

      for (final fps in fpsList) {
        var count = 0;

        await tester.pumpWidget(
          TiltWidget(
            fps: fps,
            onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
              count++;
            },
          ),
        );

        await tester.timedDrag(
          tiltWidgetFinder,
          const Offset(0.0, 5.0),
          const Duration(milliseconds: 1000),
          frequency: fpsList[0].toDouble(),
        );
        await tester.pumpAndSettle();

        /// timedDrag 会多 1 次触发
        expect(count, fps + 1);
      }
    });
  });

  group('Tilt didUpdateWidget ::', () {
    testWidgets('tiltController', (WidgetTester tester) async {
      final tiltController1 = TiltController();
      final tiltController2 = TiltController();
      final dataList = <TiltController>[
        tiltController1,
        tiltController2,
      ];

      for (final data in dataList) {
        await tester.pumpWidget(
          TiltWidget(tiltController: data),
        );

        await tester.pumpAndSettle();
        expect(data.hasListener, true);
      }

      await tiltController1.dispose();
      await tiltController2.dispose();

      expect(tiltController1.hasListener, false);
      expect(tiltController2.hasListener, false);
    });

    testWidgets('disable', (WidgetTester tester) async {
      final dataList = <bool>[true, false];

      for (final data in dataList) {
        var count = 0;

        await tester.pumpWidget(
          TiltWidget(
            disable: data,
            onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
              count++;
            },
          ),
        );

        await tester.timedDrag(
          tiltWidgetFinder,
          const Offset(0.0, 5.0),
          const Duration(milliseconds: 1000),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();
        expect(count > 0, !data);
      }
    });

    testWidgets('fps', (WidgetTester tester) async {
      final fpsList = <int>[120, 60];

      for (final fps in fpsList) {
        var count = 0;

        await tester.pumpWidget(
          TiltWidget(
            fps: fps,
            onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
              count++;
            },
          ),
        );

        await tester.timedDrag(
          tiltWidgetFinder,
          const Offset(0.0, 5.0),
          const Duration(milliseconds: 1000),
          frequency: fpsList[0].toDouble(),
        );
        await tester.pumpAndSettle();

        /// timedDrag 会多 1 次触发
        expect(count, fps + 1);
      }
    });

    testWidgets('tiltConfig', (WidgetTester tester) async {
      final tiltController = TiltController();
      const tiltConfig1 =
          TiltConfig(leaveDuration: Duration(milliseconds: 4000));
      const tiltConfig2 = TiltConfig(leaveDuration: Duration.zero);
      final dataList = <TiltConfig>[tiltConfig1, tiltConfig2];

      for (var i = 0; i < dataList.length; i++) {
        final data = dataList[i];
        var currentGesturesType = GesturesType.none;

        await tester.pumpWidget(
          TiltWidget(
            tiltController: tiltController,
            tiltConfig: data,
            onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
              currentGesturesType = gesturesType;
            },
          ),
        );

        /// 事件 1，触发一次 touch leave（此时总体时间在 1000ms）
        if (i == 0) {
          /// 倾斜 touch move
          tiltController.move(
            position: const Offset(0.0, 5.0),
            gesturesType: GesturesType.touch,
          );
          await tester.pump(const Duration(milliseconds: 500));
          expect(currentGesturesType, GesturesType.touch);

          /// 倾斜 touch leave
          tiltController.leave(
            position: const Offset(0.0, 5.0),
            gesturesType: GesturesType.touch,
          );
          await tester.pump(const Duration(milliseconds: 500));
        }

        /// 倾斜 controller move，测试手势协调
        ///
        /// 事件 1，触发一次 controller move（此时总体时间在 1500ms），
        /// 未结束 [tiltConfig1.leaveDuration] 的持续时间。
        ///
        /// 事件 2，触发一次 controller move，
        /// 由于重新赋值 [tiltConfig2.leaveDuration]，此时应结束持续时间。
        tiltController.move(
          position: const Offset(0.0, 5.0),
          gesturesType: GesturesType.sensors,
        );
        await tester.pump(const Duration(milliseconds: 500));

        /// 事件 1，未结束 [tiltConfig1.leaveDuration] 的持续时间。
        if (i == 0) {
          expect(currentGesturesType, GesturesType.touch);
        }

        /// 事件 2，已结束 [tiltConfig2.leaveDuration] 的持续时间。
        if (i == 1) {
          expect(currentGesturesType, GesturesType.sensors);
        }
      }

      await tiltController.dispose();
    });
  });
}
