import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'tilt_widget.dart';

void main() {
  const TiltConfig tiltConfig = TiltConfig();
  final Finder tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
  final Finder childFinder = find.text('Tilt');
  final TestPointer testPointer = TestPointer(1, PointerDeviceKind.mouse);
  group('tilt TiltConfig', () {
    testWidgets('disable true', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final TiltDataModel tiltDataExpect = TiltDataModel(
        angle: Offset(tiltConfig.angle, 0.0),
        areaProgress: const Offset(0.0, 1.0),
        position: const Offset(5.0, 0.0),
        transform: Matrix4(
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: const TiltConfig(disable: true),
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
      final TiltDataModel tiltDataInitialExpect = TiltDataModel(
        angle: Offset(tiltConfig.angle, -tiltConfig.angle),
        areaProgress: const Offset(1.0, 1.0),
        position: Offset.zero,
        transform: Matrix4(
          0.984807753012208,
          -0.030153689607045803,
          0.17101007166283433,
          0.008550503583141718,
          0.0,
          0.984807753012208,
          0.17364817766693033,
          0.008682408883346517,
          -0.17364817766693033,
          -0.17101007166283433,
          0.9698463103929541,
          0.04849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );
      final TiltDataModel tiltDataExpect = TiltDataModel(
        angle: const Offset(-8.0, 8.0),
        areaProgress: const Offset(-0.8, -0.8),
        position: const Offset(9.0, 9.0),
        transform: Matrix4(
          0.9902680687415704,
          -0.019369152030840567,
          -0.13781867790849958,
          -0.006890933895424981,
          0.0,
          0.9902680687415704,
          -0.13917310096006544,
          -0.006958655048003273,
          0.13917310096006544,
          0.13781867790849958,
          0.9806308479691596,
          0.04903154239845798,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: const TiltConfig(initial: Offset(1.0, 1.0)),
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
      final Offset hoverEventLocation = tester.getCenter(tiltWidgetFinder);

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
      final TiltDataModel tiltDataExpect = TiltDataModel(
        angle: const Offset(20.0, -20.0),
        areaProgress: const Offset(1.0, 1.0),
        position: Offset.zero,
        transform: Matrix4(
          0.9396926207859084,
          -0.11697777844051097,
          0.3213938048432697,
          0.016069690242163485,
          0.0,
          0.9396926207859084,
          0.3420201433256687,
          0.017101007166283436,
          -0.3420201433256687,
          -0.3213938048432697,
          0.8830222215594891,
          0.04415111107797446,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );
      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: const TiltConfig(angle: 20),
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
      final TiltDataModel tiltDataExpect = TiltDataModel(
        angle: Offset(tiltConfig.angle, -tiltConfig.angle),
        areaProgress: const Offset(1.0, 1.0),
        position: Offset.zero,
        transform: Matrix4(
          0.984807753012208,
          -0.030153689607045803,
          0.17101007166283433,
          0.008550503583141718,
          0.0,
          0.984807753012208,
          0.17364817766693033,
          0.008682408883346517,
          -0.17364817766693033,
          -0.17101007166283433,
          0.9698463103929541,
          0.04849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );
      final TiltDataModel tiltDataExpect2 = TiltDataModel(
        angle: Offset(-tiltConfig.angle, tiltConfig.angle),
        areaProgress: const Offset(-1.0, -1.0),
        position: Offset(tiltConfig.angle, tiltConfig.angle),
        transform: Matrix4(
          0.984807753012208,
          -0.030153689607045803,
          -0.17101007166283433,
          -0.008550503583141718,
          0.0,
          0.984807753012208,
          -0.17364817766693033,
          -0.008682408883346517,
          0.17364817766693033,
          0.17101007166283433,
          0.9698463103929541,
          0.04849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: TiltConfig(
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
          ),
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
      final TiltDataModel tiltDataExpect = TiltDataModel(
        angle: Offset(tiltConfig.angle, -tiltConfig.angle),
        areaProgress: const Offset(1.0, 1.0),
        position: Offset.zero,
        transform: Matrix4(
          0.984807753012208,
          -0.030153689607045803,
          0.17101007166283433,
          0.008550503583141718,
          0.0,
          0.984807753012208,
          0.17364817766693033,
          0.008682408883346517,
          -0.17364817766693033,
          -0.17101007166283433,
          0.9698463103929541,
          0.04849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );
      final TiltDataModel tiltDataExpect2 = TiltDataModel(
        angle: Offset.zero,
        areaProgress: Offset.zero,
        position: const Offset(5.0, 5.0),
        transform: Matrix4(
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0,
          0.05,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: TiltConfig(
            direction: <TiltDirection>[TiltDirection.top, TiltDirection.left],
          ),
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
      final TiltDataModel tiltDataExpect = TiltDataModel(
        angle: Offset(tiltConfig.angle, -tiltConfig.angle),
        areaProgress: const Offset(1.0, 1.0),
        position: Offset.zero,
        transform: Matrix4(
          0.984807753012208,
          -0.030153689607045803,
          0.17101007166283433,
          0.008550503583141718,
          0.0,
          0.984807753012208,
          0.17364817766693033,
          0.008682408883346517,
          -0.17364817766693033,
          -0.17101007166283433,
          0.9698463103929541,
          0.04849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: const TiltConfig(enableRevert: false),
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
      final Offset hoverEventLocation = tester.getCenter(tiltWidgetFinder);

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
      final TiltDataModel tiltDataExpect = TiltDataModel(
        angle: Offset(-tiltConfig.angle, tiltConfig.angle),
        areaProgress: const Offset(1.0, 1.0),
        position: Offset.zero,
        transform: Matrix4(
          0.984807753012208,
          -0.030153689607045803,
          -0.17101007166283433,
          -0.008550503583141718,
          0.0,
          0.984807753012208,
          -0.17364817766693033,
          -0.008682408883346517,
          0.17364817766693033,
          0.17101007166283433,
          0.9698463103929541,
          0.04849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: const TiltConfig(enableReverse: true),
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
      int leaveCountTest = 0;
      final TiltDataModel tiltDataExpect = TiltDataModel(
        angle: Offset(tiltConfig.angle, -tiltConfig.angle),
        areaProgress: const Offset(1.0, 1.0),
        position: Offset.zero,
        transform: Matrix4(
          0.984807753012208,
          -0.030153689607045803,
          0.17101007166283433,
          0.008550503583141718,
          0.0,
          0.984807753012208,
          0.17364817766693033,
          0.008682408883346517,
          -0.17364817766693033,
          -0.17101007166283433,
          0.9698463103929541,
          0.04849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );
      final TiltDataModel tiltDataExpect2 = TiltDataModel(
        angle: Offset.zero,
        areaProgress: Offset.zero,
        position: const Offset(5.0, 5.0),
        transform: Matrix4(
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0,
          0.05,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

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
      final TiltDataModel tiltDataExpect = TiltDataModel(
        angle: const Offset(-8.0, 8.0),
        areaProgress: const Offset(-0.8, -0.8),
        position: const Offset(9.0, 9.0),
        transform: Matrix4(
          0.9902680687415704,
          -0.019369152030840567,
          -0.13781867790849958,
          -0.006890933895424981,
          0.0,
          0.9902680687415704,
          -0.13917310096006544,
          -0.006958655048003273,
          0.13917310096006544,
          0.13781867790849958,
          0.9806308479691596,
          0.04903154239845798,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: const TiltConfig(enableGestureTouch: false),
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
      final Offset hoverEventLocation = tester.getCenter(tiltWidgetFinder);
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(4.0, 4.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect);

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('enableGestureHover false', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final TiltDataModel tiltDataExpect = TiltDataModel(
        angle: Offset(-tiltConfig.angle, tiltConfig.angle),
        areaProgress: const Offset(-1.0, -1.0),
        position: Offset(tiltConfig.angle, tiltConfig.angle),
        transform: Matrix4(
          0.984807753012208,
          -0.030153689607045803,
          -0.17101007166283433,
          -0.008550503583141718,
          0.0,
          0.984807753012208,
          -0.17364817766693033,
          -0.008682408883346517,
          0.17364817766693033,
          0.17101007166283433,
          0.9698463103929541,
          0.04849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      await tester.pumpWidget(
        TiltWidget(
          tiltConfig: const TiltConfig(enableGestureHover: false),
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// hover
      final Offset hoverEventLocation = tester.getCenter(tiltWidgetFinder);
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
