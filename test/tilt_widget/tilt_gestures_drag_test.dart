import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

void main() {
  group('tilt gestures drag', () {
    testWidgets('scroll', (WidgetTester tester) async {
      final Finder childFinder = find.text('Tilt');
      final Finder scrollFinder = find.byKey(const Key('scroll'));
      final ScrollController scrollController = ScrollController();

      /// 回调赋值
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: scrollController,
              children: const <Widget>[
                Tilt(
                  key: Key('tilt_widget'),
                  child: SizedBox(width: 100, height: 100, child: Text('Tilt')),
                ),
                SizedBox(key: Key('scroll'), height: 100, width: 100),
                SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      );

      /// onVerticalDragUpdate
      await tester.timedDrag(
        childFinder,
        const Offset(0.0, -100.0),
        const Duration(milliseconds: 1000),
      );
      await tester.pump(const Duration(milliseconds: 1000));
      expect(scrollController.offset, 0.0);
      expect(childFinder, findsOneWidget);

      /// onHorizontalDragUpdate
      await tester.timedDrag(
        childFinder,
        const Offset(-100.0, 0.0),
        const Duration(milliseconds: 1000),
      );
      await tester.pump(const Duration(milliseconds: 1000));
      expect(scrollController.offset, 0.0);
      expect(childFinder, findsOneWidget);

      /// scroll
      await tester.timedDrag(
        scrollFinder,
        const Offset(0.0, -100.0),
        const Duration(milliseconds: 1000),
        warnIfMissed: false,
      );
      await tester.pump(const Duration(milliseconds: 1000));
      expect(scrollController.offset, 100.0);
      expect(childFinder, findsNothing);
    });
  });
}
