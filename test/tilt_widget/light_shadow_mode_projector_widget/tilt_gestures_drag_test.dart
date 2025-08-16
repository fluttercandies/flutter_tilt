import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

void main() {
  group('LightShadowMode.projector :: tilt gestures drag ::', () {
    testWidgets('scroll', (WidgetTester tester) async {
      final childFinder = find.text('Tilt');
      final scrollFinder = find.byKey(const Key('scroll'));
      final scrollController = ScrollController();

      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: scrollController,
              children: const <Widget>[
                Tilt(
                  key: Key('tilt_widget'),
                  lightShadowMode: LightShadowMode.projector,
                  shadowConfig: ShadowConfig(
                    projectorScaleFrom: 2,
                    projectorScaleTo: 1,
                    projectorBlurSigmaFrom: 2,
                    projectorBlurSigmaTo: 1,
                  ),
                  child: SizedBox(width: 100, height: 100, child: Text('Tilt')),
                ),
                SizedBox(key: Key('scroll'), height: 100, width: 100),
                SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      );
      debugDefaultTargetPlatformOverride = null;

      /// onVerticalDragUpdate
      await tester.timedDrag(
        childFinder.first,
        const Offset(0.0, -100.0),
        const Duration(milliseconds: 1000),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(scrollController.offset, 0.0);
      expect(childFinder, findsNWidgets(2));

      /// onHorizontalDragUpdate
      await tester.timedDrag(
        childFinder.first,
        const Offset(-100.0, 0.0),
        const Duration(milliseconds: 1000),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(scrollController.offset, 0.0);
      expect(childFinder, findsNWidgets(2));

      /// scroll
      await tester.timedDrag(
        scrollFinder,
        const Offset(0.0, -100.0),
        const Duration(milliseconds: 1000),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(scrollController.offset, 100.0);
    });
  });
}
