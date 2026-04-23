import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'shared_widgets/tilt_parallax_widget.dart';

void main() {
  final tiltWidgetFinder = find.byKey(const Key('tilt_widget'));

  group('TiltParallax ::', () {
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

    testWidgets('child rebuild count', (WidgetTester tester) async {
      const fps = 120;
      var moveCount = 0;
      var childBuildCount = 0;

      await tester.pumpWidget(
        TiltParallaxWidget(
          fps: fps,
          tiltConfig: const TiltConfig(initial: Offset(1, 0)),
          onGestureMove: (_, __) {
            moveCount++;
          },
          childLayout: ChildLayout(
            outer: <Widget>[
              Positioned(
                child: TiltParallax(
                  child: Builder(
                    builder: (_) {
                      childBuildCount++;
                      return const SizedBox(
                        width: 10,
                        height: 10,
                        child: Text('outer'),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      await tester.timedDrag(
        tiltWidgetFinder,
        const Offset(0.0, 5.0),
        const Duration(milliseconds: 1000),
        frequency: fps.toDouble(),
      );
      await tester.pumpAndSettle();

      expect(moveCount, fps + 1);
      expect(childBuildCount, 1);
    });
  });
}
