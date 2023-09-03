import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'tilt_widget.dart';

void main() {
  final Finder tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
  final Finder childFinder = find.text('Tilt');
  group('tilt config', () {
    testWidgets('default', (WidgetTester tester) async {
      await tester.pumpWidget(const TiltWidget());
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
    });
    testWidgets('disable true', (WidgetTester tester) async {
      TiltDataModel? tiltData;
      GesturesType? gesturesType;
      await tester.pumpWidget(
        TiltWidget(
          disable: true,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            tiltData = tiltData;
            gesturesType = gesturesType;
          },
        ),
      );
      await tester.fling(tiltWidgetFinder, const Offset(0.0, -5.0), 0.1);
      expect(childFinder, findsOneWidget);
      expect(gesturesType, null);
      expect(tiltData, null);
    });
    testWidgets('fps', (WidgetTester tester) async {
      int count = 0;

      /// default
      await tester.pumpWidget(
        TiltWidget(
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            count++;
          },
        ),
      );

      await tester.timedDrag(
        tiltWidgetFinder,
        const Offset(0.0, 5.0),
        const Duration(milliseconds: 1000),
      );
      await tester.pumpAndSettle();
      expect(count, 60);

      /// 30 fps
      count = 0;
      await tester.pumpWidget(
        TiltWidget(
          fps: 30,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            count++;
          },
        ),
      );

      await tester.timedDrag(
        tiltWidgetFinder,
        const Offset(0.0, 5.0),
        const Duration(milliseconds: 1000),
      );
      await tester.pumpAndSettle();
      expect(count, 30);

      /// 10 fps
      count = 0;
      await tester.pumpWidget(
        TiltWidget(
          fps: 10,
          onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
            count++;
          },
        ),
      );
      await tester.timedDrag(
        tiltWidgetFinder,
        const Offset(0.0, 5.0),
        const Duration(milliseconds: 1000),
      );
      await tester.pumpAndSettle();
      expect(count, 10);
    });
  });
}
