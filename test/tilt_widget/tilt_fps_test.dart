import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'tilt_widget.dart';

void main() {
  final Finder tiltWidgetFinder = find.byKey(const Key('tilt_widget'));
  testWidgets('tilt fps', (WidgetTester tester) async {
    int count = 0;

    /// default
    await tester.pumpWidget(
      TiltWidget(
        onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
          count++;
        },
      ),
    );
    await tester.fling(
      tiltWidgetFinder,
      const Offset(0.0, 10.0),
      10,
      initialOffset: const Offset(-5, -5),
    );
    expect(count, 52);

    /// 30
    count = 0;
    await tester.pumpWidget(
      TiltWidget(
        fps: 30,
        onGestureMove: (TiltDataModel tiltData, GesturesType gesturesType) {
          count++;
        },
      ),
    );
    await tester.fling(
      tiltWidgetFinder,
      const Offset(0.0, 10.0),
      10,
      initialOffset: const Offset(-5, -5),
    );
    expect(count, 27);
  });
}
