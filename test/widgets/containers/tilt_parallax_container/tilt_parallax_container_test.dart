import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import '../../shared_widgets/tilt_parallax_container_widget.dart';

void main() {
  group('TiltParallaxContainer ::', () {
    testWidgets('TiltConfig enableReverse true', (WidgetTester tester) async {
      final outerFinder = find.text('outer');
      final innerFinder = find.text('inner');
      final behindFinder = find.text('behind');

      await tester.pumpWidget(
        const TiltParallaxContainerWidget(
          tiltConfig: TiltConfig(initial: Offset(1, 0), enableReverse: true),
        ),
      );

      await tester.pumpAndSettle();
      final outerLocation = tester.getCenter(outerFinder);
      final innerLocation = tester.getCenter(innerFinder);
      final behindLocation = tester.getCenter(behindFinder);
      expect(
        outerLocation,
        const Offset(5.938664654836236, 14.999999999999995),
      );
      expect(
        innerLocation,
        const Offset(5.938664654836236, 14.999999999999995),
      );
      expect(
        behindLocation,
        const Offset(5.938664654836236, 14.999999999999995),
      );
    });
  });
}
