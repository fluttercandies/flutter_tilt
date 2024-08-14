import 'package:flutter/material.dart';
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
      final ScrollController scrollController = ScrollController();

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
