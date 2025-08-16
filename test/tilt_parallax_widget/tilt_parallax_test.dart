import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'tilt_parallax_widget.dart';

void main() {
  group('tilt parallax ::', () {
    testWidgets('default', (WidgetTester tester) async {
      final outerFinder = find.text('outer');
      final innerFinder = find.text('inner');
      final behindFinder = find.text('behind');

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
              ),
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
              ),
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
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final outerLocation = tester.getCenter(outerFinder);
      final innerLocation = tester.getCenter(innerFinder);
      final behindLocation = tester.getCenter(behindFinder);
      expect(
        outerLocation,
        const Offset(24.061335345163766, 14.999999999999998),
      );
      expect(
        innerLocation,
        const Offset(24.061335345163766, 14.999999999999998),
      );
      expect(
        behindLocation,
        const Offset(24.061335345163766, 14.999999999999998),
      );
    });
    testWidgets('TiltConfig enableReverse true', (WidgetTester tester) async {
      final outerFinder = find.text('outer');
      final innerFinder = find.text('inner');
      final behindFinder = find.text('behind');

      await tester.pumpWidget(
        const TiltParallaxWidget(
          tiltConfig: TiltConfig(initial: Offset(1, 0), enableReverse: true),
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
              ),
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
              ),
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
              ),
            ],
          ),
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
