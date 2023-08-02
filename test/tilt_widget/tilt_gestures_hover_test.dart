import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'tilt_widget.dart';

void main() {
  group('tilt gestures hover', () {
    const TiltConfig tiltConfig = TiltConfig();
    final Finder tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
    final Finder childFinder = find.text('Tilt');
    final TestPointer testPointer = TestPointer(1, PointerDeviceKind.mouse);
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

    testWidgets('gestures move leave', (WidgetTester tester) async {
      TiltDataModel? _moveTiltData;
      TiltDataModel? _leaveTiltData;
      GesturesType? _moveGesturesType;
      GesturesType? _leaveGesturesType;

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

      /// mouse hover
      final Offset hoverEventLocation = tester.getCenter(tiltWidgetFinder);

      /// 倾斜 hover move
      await tester.sendEventToBinding(testPointer.hover(hoverEventLocation));
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(_moveGesturesType, GesturesType.hover);
      expect(_moveTiltData != null, true);

      /// 倾斜 hover leave
      await tester.sendEventToBinding(testPointer.hover(const Offset(-1, -1)));
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(_leaveGesturesType, GesturesType.hover);
      expect(_leaveTiltData, _leaveTiltDataExpect);

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
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
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
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(0.0, -6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move bottom', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
        angle: const Offset(-8.0, 0.0),
        areaProgress: const Offset(0.0, -0.8),
        position: const Offset(5.0, 9.0),
        transform: Matrix4(
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.9902680687415704,
          -0.13917310096006544,
          -0.006958655048003273,
          0.0,
          0.13917310096006544,
          0.9902680687415704,
          0.049513403437078524,
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
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
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
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(0.0, 6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
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
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
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
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-6.0, 0.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move right', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
        angle: const Offset(0.0, 8.0),
        areaProgress: const Offset(-0.8, 0.0),
        position: const Offset(9.0, 5.0),
        transform: Matrix4(
          0.9902680687415704,
          0.0,
          -0.13917310096006544,
          -0.006958655048003273,
          0.0,
          1.0,
          0.0,
          0.0,
          0.13917310096006544,
          0.0,
          0.9902680687415704,
          0.049513403437078524,
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
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
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
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(6.0, 0.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
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
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
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
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-6.0, -6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move top right', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
        angle: Offset(tiltConfig.angle, 8.0),
        areaProgress: const Offset(-0.8, 1.0),
        position: const Offset(9.0, 0.0),
        transform: Matrix4(
          0.9902680687415704,
          0.024167155361971074,
          -0.1370587488362232,
          -0.006852937441811161,
          0.0,
          0.984807753012208,
          0.17364817766693033,
          0.008682408883346517,
          0.13917310096006544,
          -0.17195824553872419,
          0.9752236716571246,
          0.048761183582856235,
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
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
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
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(6.0, -6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move bottom left', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
        angle: Offset(-8.0, -tiltConfig.angle),
        areaProgress: const Offset(1.0, -0.8),
        position: const Offset(0.0, 9.0),
        transform: Matrix4(
          0.984807753012208,
          0.024167155361971074,
          0.17195824553872419,
          0.008597912276936211,
          0.0,
          0.9902680687415704,
          -0.13917310096006544,
          -0.006958655048003273,
          -0.17364817766693033,
          0.1370587488362232,
          0.9752236716571246,
          0.048761183582856235,
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
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
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
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(-6.0, 6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
    testWidgets('move bottom right', (WidgetTester tester) async {
      TiltDataModel? _tiltData;
      GesturesType? _gesturesType;
      final TiltDataModel _tiltDataExpect = TiltDataModel(
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

      /// 回调赋值
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
          },
          onGestureLeave: (TiltDataModel tiltData, GesturesType gesturesType) {
            _tiltData = tiltData;
            _gesturesType = gesturesType;
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
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _tiltDataExpect, reason: '倾斜-不超范围');

      /// 倾斜-超范围
      await tester.sendEventToBinding(
        testPointer.hover(hoverEventLocation + const Offset(6.0, 6.0)),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(_gesturesType, GesturesType.hover);
      expect(_tiltData, _leaveTiltDataExpect, reason: '倾斜-超范围');

      await tester.sendEventToBinding(testPointer.removePointer());
    });
  });
}
