import 'dart:async' show StreamController;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'tilt_widget.dart';

void main() {
  final tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
  final childFinder = find.text('Tilt');

  group('tilt config ::', () {
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
                  child: const SizedBox(
                    width: 100,
                    height: 100,
                    child: Text('Tilt'),
                  ),
                  onGestureMove: (
                    TiltDataModel tiltData,
                    GesturesType gesturesType,
                  ) {
                    tiltDataTest = tiltData;
                    gesturesTypeTest = gesturesType;
                  },
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
        expect(count, fps);
      }
    });
  });

  group('didUpdateWidget ::', () {
    testWidgets('tiltStreamController', (WidgetTester tester) async {
      final tiltStreamController1 =
          StreamController<TiltStreamModel>.broadcast();
      final tiltStreamController2 =
          StreamController<TiltStreamModel>.broadcast();
      final dataList = <StreamController<TiltStreamModel>>[
        tiltStreamController1,
        tiltStreamController2,
      ];

      for (final data in dataList) {
        await tester.pumpWidget(
          TiltWidget(tiltStreamController: data),
        );

        await tester.pumpAndSettle();
        expect(data.hasListener, true);
      }
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
      final dataList = <int>[120, 60];

      for (final data in dataList) {
        var count = 0;

        await tester.pumpWidget(
          TiltWidget(
            fps: data,
            onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
              count++;
            },
          ),
        );

        await tester.timedDrag(
          tiltWidgetFinder,
          const Offset(0.0, 5.0),
          const Duration(milliseconds: 1000),
          frequency: dataList[0].toDouble(),
        );
        await tester.pumpAndSettle();
        expect(count, data);
      }
    });

    testWidgets('tiltConfig', (WidgetTester tester) async {
      final tiltStreamController =
          StreamController<TiltStreamModel>.broadcast();
      const tiltConfig1 =
          TiltConfig(leaveDuration: Duration(milliseconds: 4000));
      const tiltConfig2 = TiltConfig(leaveDuration: Duration.zero);
      final dataList = <TiltConfig>[tiltConfig1, tiltConfig2];

      for (var i = 0; i < dataList.length; i++) {
        final data = dataList[i];
        var currentGesturesType = GesturesType.none;

        await tester.pumpWidget(
          TiltWidget(
            tiltStreamController: tiltStreamController,
            tiltConfig: data,
            onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
              currentGesturesType = gesturesType;
            },
          ),
        );

        /// 事件 1，触发一次 touch leave（此时总体时间在 1000ms）
        if (i == 0) {
          /// 倾斜 touch move
          tiltStreamController.sink.add(
            const TiltStreamModel(
              position: Offset(0.0, 5.0),
              gesturesType: GesturesType.touch,
              gestureUse: true,
            ),
          );
          await tester.pump(const Duration(milliseconds: 500));
          expect(currentGesturesType, GesturesType.touch);

          /// 倾斜 touch leave
          tiltStreamController.sink.add(
            const TiltStreamModel(
              position: Offset(0.0, 5.0),
              gesturesType: GesturesType.touch,
              gestureUse: false,
            ),
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
        tiltStreamController.sink.add(
          const TiltStreamModel(
            position: Offset(0.0, 5.0),
            gesturesType: GesturesType.sensors,
            gestureUse: true,
          ),
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
    });
  });
}
