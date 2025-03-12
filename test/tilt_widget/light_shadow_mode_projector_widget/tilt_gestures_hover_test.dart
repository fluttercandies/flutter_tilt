import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:flutter_tilt/src/internal/tilt_data.dart';
import 'tilt_widget_projector.dart';

void main() {
  group('LightShadowMode.projector :: tilt gestures hover ::', () {
    const TiltConfig tiltConfig = TiltConfig();
    TiltData tiltDataTestCalculate(Offset areaProgress) => TiltData(
          isInit: true,
          width: 10,
          height: 10,
          areaProgress: areaProgress,
          tiltConfig: tiltConfig,
        );

    final Finder tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
    final Finder childFinder = find.text('Tilt');
    final TestPointer testPointer = TestPointer(1, PointerDeviceKind.mouse);
    final TiltDataModel leaveTiltDataExpect =
        tiltDataTestCalculate(Offset.zero).data;

    testWidgets('gestures move leave', (WidgetTester tester) async {
      TiltDataModel? moveTiltDataTest;
      TiltDataModel? leaveTiltDataTest;
      GesturesType? moveGesturesTypeTest;
      GesturesType? leaveGesturesTypeTest;

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidgetProjector(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            moveTiltDataTest = tiltData;
            moveGesturesTypeTest = gesturesType;
          },
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            leaveTiltDataTest = tiltData;
            leaveGesturesTypeTest = gesturesType;
          },
        ),
      );

      /// mouse hover
      final Offset hoverEventLocation = tester.getCenter(tiltWidgetFinder);

      /// 倾斜 hover move
      await tester.sendEventToBinding(testPointer.hover(hoverEventLocation));
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(moveGesturesTypeTest, GesturesType.hover);
      expect(moveTiltDataTest != null, true);

      /// 倾斜 hover leave
      await tester.sendEventToBinding(testPointer.hover(const Offset(-1, -1)));
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(leaveGesturesTypeTest, GesturesType.hover);
      expect(leaveTiltDataTest, leaveTiltDataExpect);

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move top', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final TiltDataModel tiltDataExpect =
          tiltDataTestCalculate(const Offset(0.0, 1.0)).data;

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidgetProjector(
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

      /// 倾斜-不超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(0.0, -5.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(0.0, -6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move bottom', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final TiltDataModel tiltDataExpect =
          tiltDataTestCalculate(const Offset(0.0, -0.8)).data;

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidgetProjector(
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

      /// 倾斜-不超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(0.0, 4.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(0.0, 6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move left', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final TiltDataModel tiltDataExpect =
          tiltDataTestCalculate(const Offset(1.0, 0.0)).data;

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidgetProjector(
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

      /// 倾斜-不超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-5.0, 0.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-6.0, 0.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move right', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final TiltDataModel tiltDataExpect =
          tiltDataTestCalculate(const Offset(-0.8, 0.0)).data;

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidgetProjector(
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

      /// 倾斜-不超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(4.0, 0.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(6.0, 0.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move top left', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final TiltDataModel tiltDataExpect =
          tiltDataTestCalculate(const Offset(1.0, 1.0)).data;

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidgetProjector(
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

      /// 倾斜-不超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-5.0, -5.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-6.0, -6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move top right', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final TiltDataModel tiltDataExpect =
          tiltDataTestCalculate(const Offset(-0.8, 1.0)).data;

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidgetProjector(
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

      /// 倾斜-不超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(4.0, -5.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(6.0, -6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move bottom left', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final TiltDataModel tiltDataExpect =
          tiltDataTestCalculate(const Offset(1.0, -0.8)).data;

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidgetProjector(
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

      /// 倾斜-不超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-5.0, 4.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-6.0, 6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move bottom right', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final TiltDataModel tiltDataExpect =
          tiltDataTestCalculate(const Offset(-0.8, -0.8)).data;

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidgetProjector(
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

      /// 倾斜-不超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(4.0, 4.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(6.0, 6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.hover);
      expect(tiltDataTest, leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
  });
}
