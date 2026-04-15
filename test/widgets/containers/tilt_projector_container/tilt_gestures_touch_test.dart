import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:flutter_tilt/src/internal/tilt_data.dart';
import '../../shared_widgets/tilt_projector_container_widget.dart';

void main() {
  group('TiltProjectorContainer :: tilt gestures touch ::', () {
    const tiltConfig = TiltConfig();
    TiltData tiltDataTestCalculate(Offset areaProgress) => TiltData(
          isInit: true,
          width: 10,
          height: 10,
          areaProgress: areaProgress,
          tiltConfig: tiltConfig,
        );

    final tiltScaffoldFinder = find.byKey(const Key('tilt_scaffold'));
    final tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
    final childFinder = find.text('Tilt');
    final testPointer = TestPointer();

    testWidgets('gestures move leave', (WidgetTester tester) async {
      TiltDataModel? moveTiltDataTest;
      TiltDataModel? leaveTiltDataTest;
      GesturesType? moveGesturesTypeTest;
      GesturesType? leaveGesturesTypeTest;
      final leaveTiltDataTestExpect =
          tiltDataTestCalculate(Offset.zero).toModel();

      /// 回调赋值
      await tester.pumpWidget(
        TiltProjectorContainerWidget(
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

      /// 倾斜 touch move
      await tester.fling(tiltWidgetFinder, const Offset(0.0, 5.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(moveGesturesTypeTest, GesturesType.touch);
      expect(moveTiltDataTest != null, true);

      /// 倾斜 touch leave
      await tester.fling(tiltScaffoldFinder, const Offset(0.0, -1.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(leaveGesturesTypeTest, GesturesType.touch);
      expect(leaveTiltDataTest, leaveTiltDataTestExpect);
    });
    testWidgets('onPointerCancel', (WidgetTester tester) async {
      await tester.pumpWidget(const TiltProjectorContainerWidget());

      final location = tester.getCenter(tiltWidgetFinder);
      await tester.sendEventToBinding(testPointer.down(location));
      await tester.sendEventToBinding(testPointer.cancel());
      await tester.pumpAndSettle(const TiltConfig().leaveDuration);
      expect(childFinder, findsNWidgets(2));

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move top', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final tiltDataExpect =
          tiltDataTestCalculate(const Offset(0.0, 1.0)).toModel();

      /// 回调赋值
      await tester.pumpWidget(
        TiltProjectorContainerWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(0.0, -5.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(0.0, -6.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move bottom', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final tiltDataExpect =
          tiltDataTestCalculate(const Offset(0.0, -1.0)).toModel();

      /// 回调赋值
      await tester.pumpWidget(
        TiltProjectorContainerWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(0.0, 5.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(0.0, 6.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move left', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final tiltDataExpect =
          tiltDataTestCalculate(const Offset(1.0, 0.0)).toModel();

      /// 回调赋值
      await tester.pumpWidget(
        TiltProjectorContainerWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(-5.0, 0.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(-6.0, 0.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move right', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final tiltDataExpect =
          tiltDataTestCalculate(const Offset(-1.0, 0.0)).toModel();

      /// 回调赋值
      await tester.pumpWidget(
        TiltProjectorContainerWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(5.0, 0.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(6.0, 0.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move top left', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final tiltDataExpect =
          tiltDataTestCalculate(const Offset(1.0, 1.0)).toModel();

      /// 回调赋值
      await tester.pumpWidget(
        TiltProjectorContainerWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(-5.0, -5.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(-6.0, -6.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move top right', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final tiltDataExpect =
          tiltDataTestCalculate(const Offset(-1.0, 1.0)).toModel();

      /// 回调赋值
      await tester.pumpWidget(
        TiltProjectorContainerWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(5.0, -5.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(6.0, -6.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move bottom left', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final tiltDataExpect =
          tiltDataTestCalculate(const Offset(1.0, -1.0)).toModel();

      /// 回调赋值
      await tester.pumpWidget(
        TiltProjectorContainerWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(-5.0, 5.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(-6.0, 6.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move bottom right', (WidgetTester tester) async {
      TiltDataModel? tiltDataTest;
      GesturesType? gesturesTypeTest;
      final tiltDataExpect =
          tiltDataTestCalculate(const Offset(-1.0, -1.0)).toModel();

      /// 回调赋值
      await tester.pumpWidget(
        TiltProjectorContainerWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltDataTest = tiltData;
            gesturesTypeTest = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(5.0, 5.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(6.0, 6.0), 0.1);
      expect(childFinder, findsNWidgets(2));
      expect(gesturesTypeTest, GesturesType.touch);
      expect(tiltDataTest, tiltDataExpect, reason: '倾斜-超范围');
    });

    testWidgets('ShadowConfig.disable = true', (WidgetTester tester) async {
      TiltDataModel? moveTiltDataTest;
      TiltDataModel? leaveTiltDataTest;
      GesturesType? moveGesturesTypeTest;
      GesturesType? leaveGesturesTypeTest;
      final leaveTiltDataTestExpect =
          tiltDataTestCalculate(Offset.zero).toModel();

      /// 回调赋值
      await tester.pumpWidget(
        TiltProjectorContainerWidget(
          shadowConfig: const ShadowProjectorConfig(disable: true),
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

      /// 倾斜 touch move
      await tester.fling(tiltWidgetFinder, const Offset(0.0, 5.0), 0.1);
      expect(childFinder, findsNWidgets(1));
      expect(moveGesturesTypeTest, GesturesType.touch);
      expect(moveTiltDataTest != null, true);

      /// 倾斜 touch leave
      await tester.fling(tiltScaffoldFinder, const Offset(0.0, -1.0), 0.1);
      expect(childFinder, findsNWidgets(1));
      expect(leaveGesturesTypeTest, GesturesType.touch);
      expect(leaveTiltDataTest, leaveTiltDataTestExpect);
    });
  });
}
