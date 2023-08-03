import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'tilt_widget.dart';

void main() {
  group('tilt gestures touch', () {
    const TiltConfig tiltConfig = TiltConfig();
    final Finder tiltScaffoldFinder = find.byKey(const Key('tilt_scaffold'));
    final Finder tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
    final Finder childFinder = find.text('Tilt');
    final TestPointer testPointer = TestPointer();

    testWidgets('gestures move leave', (WidgetTester tester) async {
      TiltDataModel? _moveTiltData;
      TiltDataModel? _leaveTiltData;
      GesturesType? _moveGesturesType;
      GesturesType? _leaveGesturesType;
      final TiltDataModel _leaveTiltDataExpect = TiltDataModel(
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

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            _moveTiltData = tiltData;
            _moveGesturesType = gesturesType;
          },
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            _leaveTiltData = tiltData;
            _leaveGesturesType = gesturesType;
          },
        ),
      );

      /// 倾斜 touch move
      await tester.fling(tiltWidgetFinder, const Offset(0.0, 5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_moveGesturesType, GesturesType.touch);
      expect(_moveTiltData != null, true);

      /// 倾斜 touch leave
      await tester.fling(tiltScaffoldFinder, const Offset(0.0, -1.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_leaveGesturesType, GesturesType.touch);
      expect(_leaveTiltData, _leaveTiltDataExpect);
    });
    testWidgets('onPointerCancel', (WidgetTester tester) async {
      await tester.pumpWidget(const TiltWidget());

      final Offset location = tester.getCenter(tiltWidgetFinder);
      await tester.sendEventToBinding(testPointer.down(location));
      await tester.sendEventToBinding(testPointer.cancel());
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move top', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
        angle: Offset(tiltConfig.angle, 0.0),
        areaProgress: const Offset(0.0, 1.0),
        position: const Offset(5.0, 0.0),
        transform: Matrix4(
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.984807753012208,
          0.17364817766693033,
          0.008682408883346517,
          0.0,
          -0.17364817766693033,
          0.984807753012208,
          0.0492403876506104,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(0.0, -5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(0.0, -6.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move bottom', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
        angle: Offset(-tiltConfig.angle, 0.0),
        areaProgress: const Offset(0.0, -1.0),
        position: const Offset(5.0, 10.0),
        transform: Matrix4(
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.984807753012208,
          -0.17364817766693033,
          -0.008682408883346517,
          0.0,
          0.17364817766693033,
          0.984807753012208,
          0.0492403876506104,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(0.0, 5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(0.0, 6.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move left', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
        angle: Offset(0.0, -tiltConfig.angle),
        areaProgress: const Offset(1.0, 0.0),
        position: const Offset(0.0, 5.0),
        transform: Matrix4(
          0.984807753012208,
          0.0,
          0.17364817766693033,
          0.008682408883346517,
          0.0,
          1.0,
          0.0,
          0.0,
          -0.17364817766693033,
          0.0,
          0.984807753012208,
          0.0492403876506104,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(-5.0, 0.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(-6.0, 0.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move right', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
        angle: Offset(0.0, tiltConfig.angle),
        areaProgress: const Offset(-1.0, 0.0),
        position: Offset(tiltConfig.angle, 5.0),
        transform: Matrix4(
          0.984807753012208,
          0.0,
          -0.17364817766693033,
          -0.008682408883346517,
          0.0,
          1.0,
          0.0,
          0.0,
          0.17364817766693033,
          0.0,
          0.984807753012208,
          0.0492403876506104,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(5.0, 0.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(6.0, 0.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move top left', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
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

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(-5.0, -5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(-6.0, -6.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move top right', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
        angle: Offset(tiltConfig.angle, tiltConfig.angle),
        areaProgress: const Offset(-1.0, 1.0),
        position: Offset(tiltConfig.angle, 0.0),
        transform: Matrix4(
          0.984807753012208,
          0.030153689607045803,
          -0.17101007166283433,
          -0.008550503583141718,
          0.0,
          0.984807753012208,
          0.17364817766693033,
          0.008682408883346517,
          0.17364817766693033,
          -0.17101007166283433,
          0.9698463103929541,
          0.04849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(5.0, -5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(6.0, -6.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move bottom left', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
        angle: Offset(-tiltConfig.angle, -tiltConfig.angle),
        areaProgress: const Offset(1.0, -1.0),
        position: Offset(0.0, tiltConfig.angle),
        transform: Matrix4(
          0.984807753012208,
          0.030153689607045803,
          0.17101007166283433,
          0.008550503583141718,
          0.0,
          0.984807753012208,
          -0.17364817766693033,
          -0.008682408883346517,
          -0.17364817766693033,
          0.17101007166283433,
          0.9698463103929541,
          0.04849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
      );

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(-5.0, 5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(-6.0, 6.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-超范围');
    });
    testWidgets('move bottom right', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
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

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
          },
        ),
      );

      /// 倾斜-不超范围
      await tester.fling(tiltWidgetFinder, const Offset(5.0, 5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.fling(tiltWidgetFinder, const Offset(6.0, 6.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.touch);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-超范围');
    });
  });
}
