import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:flutter_tilt/src/internal/tilt_data.dart';
import 'tilt_widget.dart';

void main() {
  const tiltConfig = TiltConfig();
  TiltData tiltDataTestCalculate({
    required Offset areaProgress,
    TiltConfig tiltConfig = tiltConfig,
  }) =>
      TiltData(
        isInit: true,
        width: 10,
        height: 10,
        areaProgress: areaProgress,
        tiltConfig: tiltConfig,
      );

  final tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
  final childFinder = find.text('Tilt');
  final testPointer = TestPointer(1, PointerDeviceKind.mouse);

  group('tilt TiltConfig ::', () {
    testWidgets('disable true', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      const tiltConfigTest = TiltConfig(disable: true);
      final tiltDataExpect = tiltDataTestCalculate(
        areaProgress: const Offset(0.0, 1.0),
        tiltConfig: tiltConfigTest,
      ).data;

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: tiltConfigTest,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );
      await tester.fling(tiltWidgetFinder, const Offset(0.0, -5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect);
    });

    testWidgets('initial', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      const tiltConfigTest = TiltConfig(initial: Offset(1.0, 1.0));
      final tiltDataInitialExpect = tiltDataTestCalculate(
        areaProgress: const Offset(1.0, 1.0),
        tiltConfig: tiltConfigTest,
      ).data;
      final tiltDataExpect = tiltDataTestCalculate(
        areaProgress: const Offset(-0.8, -0.8),
        tiltConfig: tiltConfigTest,
      ).data;

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: tiltConfigTest,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// mouse hover
      final hoverEventLocation = tester.getCenter(tiltWidgetFinder);

      /// 倾斜
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(4.0, 4.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜');

      /// 还原
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(6.0, 6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataInitialExpect, reason: '还原');

      await tester.sendEventToBinding(testPointer.removePointer());
    });

    testWidgets('angle', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      const tiltConfigTest = TiltConfig(angle: 20);
      final tiltDataExpect = tiltDataTestCalculate(
        areaProgress: const Offset(1.0, 1.0),
        tiltConfig: tiltConfigTest,
      ).data;

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: tiltConfigTest,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      await tester.fling(tiltWidgetFinder, const Offset(-5.0, -5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect);
    });

    testWidgets('direction all', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final tiltConfigTest = const TiltConfig(
        direction: <TiltDirection>[
          TiltDirection.none,
          TiltDirection.top,
          TiltDirection.bottom,
          TiltDirection.left,
          TiltDirection.right,
          TiltDirection.topLeft,
          TiltDirection.topRight,
          TiltDirection.bottomLeft,
          TiltDirection.bottomRight,
        ],
      );
      final tiltDataExpect = tiltDataTestCalculate(
        areaProgress: const Offset(1.0, 1.0),
        tiltConfig: tiltConfigTest,
      ).data;
      final tiltDataExpect2 = tiltDataTestCalculate(
        areaProgress: const Offset(-1.0, -1.0),
        tiltConfig: tiltConfigTest,
      ).data;

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: tiltConfigTest,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 左上
      await tester.fling(tiltWidgetFinder, const Offset(-5.0, -5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect);

      /// 右下
      await tester.fling(tiltWidgetFinder, const Offset(5.0, 5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect2);
    });

    testWidgets('direction part', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final tiltConfigTest = const TiltConfig(
        direction: <TiltDirection>[TiltDirection.top, TiltDirection.left],
      );
      final tiltDataExpect = tiltDataTestCalculate(
        areaProgress: const Offset(1.0, 1.0),
        tiltConfig: tiltConfigTest,
      ).data;
      final tiltDataExpect2 = tiltDataTestCalculate(
        areaProgress: Offset.zero,
        tiltConfig: tiltConfigTest,
      ).data;

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: tiltConfigTest,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 合法
      await tester.fling(tiltWidgetFinder, const Offset(-5.0, -5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect);

      /// 不合法
      await tester.fling(tiltWidgetFinder, const Offset(5.0, 5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect2);
    });

    testWidgets('enableRevert false', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      const tiltConfigTest = TiltConfig(enableRevert: false);
      final tiltDataExpect = tiltDataTestCalculate(
        areaProgress: const Offset(1.0, 1.0),
        tiltConfig: tiltConfigTest,
      ).data;

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: tiltConfigTest,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// mouse hover
      final hoverEventLocation = tester.getCenter(tiltWidgetFinder);

      /// 倾斜
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-5.0, -5.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜');

      /// 不还原
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-6.0, -6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '不还原');

      await tester.sendEventToBinding(testPointer.removePointer());
    });

    testWidgets('enableReverse true', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      const tiltConfigTest = TiltConfig(enableReverse: true);
      final tiltDataExpect = tiltDataTestCalculate(
        areaProgress: const Offset(1.0, 1.0),
        tiltConfig: tiltConfigTest,
      ).data;

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: tiltConfigTest,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      await tester.fling(tiltWidgetFinder, const Offset(-5.0, -5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect);
    });

    testWidgets('enableOutsideAreaMove false', (WidgetTester tester) async {
      TiltDataModel? moveTiltDataTest;
      TiltDataModel? leaveTiltDataTest;
      GesturesType? moveGesturesTypeTest;
      GesturesType? leaveGesturesTypeTest;
      var leaveCountTest = 0;
      const tiltConfigTest = TiltConfig(enableOutsideAreaMove: false);
      final tiltDataExpect = tiltDataTestCalculate(
        areaProgress: const Offset(1.0, 1.0),
        tiltConfig: tiltConfigTest,
      ).data;
      final tiltDataExpect2 = tiltDataTestCalculate(
        areaProgress: Offset.zero,
        tiltConfig: tiltConfigTest,
      ).data;

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: const TiltConfig(enableOutsideAreaMove: false),
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            moveTiltDataTest = tiltData;
            moveGesturesTypeTest = gesturesType;
          },
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            leaveCountTest++;
            leaveTiltDataTest = tiltData;
            leaveGesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(-5.0, -5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(moveGesturesTypeTest, GesturesType.touch);
      expect(moveTiltDataTest, tiltDataExpect);

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(-6.0, -6.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(leaveGesturesTypeTest, GesturesType.touch);
      expect(leaveCountTest == 1, true);
      expect(leaveTiltDataTest, tiltDataExpect2);
    });

    testWidgets('enableGestureTouch false', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      const tiltConfigTest = TiltConfig(enableGestureTouch: false);
      final tiltDataExpect = tiltDataTestCalculate(
        areaProgress: const Offset(-0.8, -0.8),
        tiltConfig: tiltConfigTest,
      ).data;

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: tiltConfigTest,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// touch
      await tester.fling(tiltWidgetFinder, const Offset(5.0, 5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, null);
      expect(tiltDataTest, null);

      /// hover
      final hoverEventLocation = tester.getCenter(tiltWidgetFinder);
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(4.0, 4.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect);

      await tester.sendEventToBinding(testPointer.removePointer());
    });

    testWidgets('enableGestureTouch false - scrolling',
        (WidgetTester tester) async {
      final scrollController = ScrollController();

      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;

      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: scrollController,
              children: <Widget>[
                Tilt(
                  key: const Key('tilt_widget'),
                  tiltConfig: const TiltConfig(enableGestureTouch: false),
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
      debugDefaultTargetPlatformOverride = null;

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

    testWidgets('enableGestureHover false', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      const tiltConfigTest = TiltConfig(enableGestureHover: false);
      final tiltDataExpect = tiltDataTestCalculate(
        areaProgress: const Offset(-1.0, -1.0),
        tiltConfig: tiltConfigTest,
      ).data;

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: tiltConfigTest,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// hover
      final hoverEventLocation = tester.getCenter(tiltWidgetFinder);
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(4.0, 4.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, null);
      expect(tiltDataTest, null);

      /// touch
      await tester.fling(tiltWidgetFinder, const Offset(5.0, 5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect);

      await tester.sendEventToBinding(testPointer.removePointer());
    });
  });
}
