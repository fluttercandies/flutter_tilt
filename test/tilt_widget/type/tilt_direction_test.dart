import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';

void main() {
  group('TiltDirection', () {
    test('value', () {
      final TiltDirection tiltDirection = -const TiltDirection(1.0, 1.0);
      expect(tiltDirection.dx, -1.0);
      expect(tiltDirection.dy, -1.0);
      expect(
        tiltDirection.toString(),
        'TiltDirection(${tiltDirection.dx}, ${tiltDirection.dy})',
      );
    });
    test('validator', () {
      final TiltDirection tiltDirection = TiltDirection.validator(
        const TiltDirection(1.0, 1.0),
        <TiltDirection>[
          TiltDirection.none,
          TiltDirection.top,
          TiltDirection.bottom,
          TiltDirection.left,
          TiltDirection.right,
          TiltDirection.topLeft,
          TiltDirection.topRight,
          TiltDirection.bottomLeft,
          TiltDirection.bottomRight,
        ],
      );
      expect(tiltDirection.dx, 1.0);
      expect(tiltDirection.dy, 1.0);
    });
    test('operator +', () {
      final TiltDirection tiltDirection =
          const TiltDirection(0.5, 0.5) + const TiltDirection(0.5, 0.5);
      expect(tiltDirection.dx, 1.0);
      expect(tiltDirection.dy, 1.0);
    });
    test('operator -', () {
      final TiltDirection tiltDirection =
          const TiltDirection(0.5, 0.5) - const TiltDirection(0.5, 0.5);
      expect(tiltDirection.dx, 0.0);
      expect(tiltDirection.dy, 0.0);
    });
    test('operator *', () {
      final TiltDirection tiltDirection = const TiltDirection(1.0, 1.0) * 0.0;
      expect(tiltDirection.dx, 0.0);
      expect(tiltDirection.dy, 0.0);
    });
    test('operator /', () {
      final TiltDirection tiltDirection = const TiltDirection(1.0, 1.0) / 1.0;
      expect(tiltDirection.dx, 1.0);
      expect(tiltDirection.dy, 1.0);
    });
    test('operator ~/', () {
      final TiltDirection tiltDirection = const TiltDirection(1.0, 1.0) ~/ 1.5;
      expect(tiltDirection.dx, 0.0);
      expect(tiltDirection.dy, 0.0);
    });
  });
}
