import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'tilt_parallax_widget.dart';

void main() {
  group('tilt parallax', () {
    testWidgets('default', (WidgetTester tester) async {
      final Finder outerFinder = find.text('outer');
      final Finder innerFinder = find.text('inner');
      final Finder behindFinder = find.text('behind');

      await tester.pumpWidget(
        const TiltParallaxWidget(
          tiltConfig: TiltConfig(initial: Offset(1, 0)),
          childLayout: ChildLayout(
            outer: <Widget>[
              Positioned(
                child: TiltParallax(
                  child: SizedBox(
                    width: 10,
                    height: 10,
                    child: Text('outer'),
                  ),
                ),
              )
            ],
            inner: <Widget>[
              Positioned(
                child: TiltParallax(
                  child: SizedBox(
                    width: 10,
                    height: 10,
                    child: Text('inner'),
                  ),
                ),
              )
            ],
            behind: <Widget>[
              Positioned(
                child: TiltParallax(
                  child: SizedBox(
                    width: 10,
                    height: 10,
                    child: Text('behind'),
                  ),
                ),
              )
            ],
          ),
        ),
      );

      final Offset outerLocation = tester.getCenter(outerFinder);
      final Offset innerLocation = tester.getCenter(innerFinder);
      final Offset behindLocation = tester.getCenter(behindFinder);
      expect(outerLocation, const Offset(25, 15));
      expect(innerLocation, const Offset(25, 15));
      expect(behindLocation, const Offset(25, 15));
    });
  });
}
