import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_config.dart';

void main() {
  group('TiltConfig ::', () {
    test('copyWith', () {
      const tiltConfig = TiltConfig();
      const tiltConfigExpect = TiltConfig(
        disable: true,
        initial: Offset(1.0, 1.0),
        angle: 1.0,
        direction: [TiltDirection.top, TiltDirection.bottom],
        enableReverse: true,
        enableGestureSensors: false,
        sensorFactor: 2.0,
        enableSensorRevert: false,
        sensorRevertFactor: 1.0,
        sensorMoveDuration: Duration.zero,
        enableGestureHover: false,
        enableGestureTouch: false,
        enableRevert: false,
        enableOutsideAreaMove: false,
        enterDuration: Duration.zero,
        moveDuration: Duration.zero,
        enterToMoveDuration: Duration.zero,
        leaveDuration: Duration.zero,
        moveCurve: Curves.bounceIn,
        enterToMoveCurve: Curves.bounceIn,
        leaveCurve: Curves.bounceIn,
        controllerMoveDuration: Duration.zero,
        controllerLeaveDuration: Duration.zero,
      );
      final tiltConfigCopyWith = tiltConfig.copyWith(
        disable: true,
        initial: const Offset(1.0, 1.0),
        angle: 1.0,
        direction: [TiltDirection.top, TiltDirection.bottom],
        enableReverse: true,
        enableGestureSensors: false,
        sensorFactor: 2.0,
        enableSensorRevert: false,
        sensorRevertFactor: 1.0,
        sensorMoveDuration: Duration.zero,
        enableGestureHover: false,
        enableGestureTouch: false,
        enableRevert: false,
        enableOutsideAreaMove: false,
        enterDuration: Duration.zero,
        moveDuration: Duration.zero,
        enterToMoveDuration: Duration.zero,
        leaveDuration: Duration.zero,
        moveCurve: Curves.bounceIn,
        enterToMoveCurve: Curves.bounceIn,
        leaveCurve: Curves.bounceIn,
        controllerMoveDuration: Duration.zero,
        controllerLeaveDuration: Duration.zero,
      );
      expect(tiltConfig, tiltConfig.copyWith());
      expect(tiltConfigCopyWith, tiltConfigExpect);
      expect(tiltConfigCopyWith.hashCode, tiltConfigExpect.hashCode);
    });

    test('copyWith - initial can be explicitly set to null', () {
      const tiltConfig = TiltConfig(initial: Offset(1.0, 1.0));
      expect(tiltConfig.copyWith().initial, const Offset(1.0, 1.0));
      expect(tiltConfig.copyWith(initial: null).initial, isNull);
    });

    test('copyWith - direction can be explicitly set to null', () {
      const tiltConfig = TiltConfig(direction: [TiltDirection.top]);
      expect(tiltConfig.copyWith().direction, [TiltDirection.top]);
      expect(tiltConfig.copyWith(direction: null).direction, isNull);
    });

    test('== and hashCode - equal direction lists are considered equal', () {
      const a = TiltConfig(
        direction: [TiltDirection.top, TiltDirection.left],
      );
      const b = TiltConfig(
        direction: [TiltDirection.top, TiltDirection.left],
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('== and hashCode - different direction lists are considered unequal',
        () {
      const a = TiltConfig(direction: [TiltDirection.top]);
      const b = TiltConfig(direction: [TiltDirection.bottom]);
      expect(a, isNot(b));
    });
  });

  group('ChildLayout ::', () {
    test('value', () {
      const layout = ChildLayout(
        outer: [Placeholder()],
        inner: [Placeholder()],
        behind: [Placeholder()],
      );
      expect(layout.outer.length, 1);
      expect(layout.inner.length, 1);
      expect(layout.behind.length, 1);
    });
  });

  group('TiltDirection ::', () {
    test('value', () {
      final tiltDirection = -const TiltDirection(1.0, 1.0);
      expect(tiltDirection.dx, -1.0);
      expect(tiltDirection.dy, -1.0);
      expect(tiltDirection, const TiltDirection(-1.0, -1.0));
      expect(tiltDirection.hashCode, const TiltDirection(-1.0, -1.0).hashCode);
      expect(
        tiltDirection.toString(),
        'TiltDirection(${tiltDirection.dx}, ${tiltDirection.dy})',
      );
    });
    test('validator', () {
      final tiltDirection = TiltDirection.validator(
        const TiltDirection(1.0, 1.0),
        const <TiltDirection>[
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

      final tiltDirection2 = TiltDirection.validator(
        const TiltDirection(1.0, 1.0),
        const <TiltDirection>[TiltDirection.none, TiltDirection(0.7, 0.4)],
      );
      expect(tiltDirection2.dx, 0.7);
      expect(tiltDirection2.dy, 0.4);
    });
    test('operator +', () {
      final tiltDirection =
          const TiltDirection(0.5, 0.5) + const TiltDirection(0.5, 0.5);
      expect(tiltDirection.dx, 1.0);
      expect(tiltDirection.dy, 1.0);
    });
    test('operator -', () {
      final tiltDirection =
          const TiltDirection(0.5, 0.5) - const TiltDirection(0.5, 0.5);
      expect(tiltDirection.dx, 0.0);
      expect(tiltDirection.dy, 0.0);
    });
    test('operator *', () {
      final tiltDirection = const TiltDirection(1.0, 1.0) * 0.0;
      expect(tiltDirection.dx, 0.0);
      expect(tiltDirection.dy, 0.0);
    });
    test('operator /', () {
      final tiltDirection = const TiltDirection(1.0, 1.0) / 1.0;
      expect(tiltDirection.dx, 1.0);
      expect(tiltDirection.dy, 1.0);
    });
    test('operator ~/', () {
      final tiltDirection = const TiltDirection(1.0, 1.0) ~/ 1.5;
      expect(tiltDirection.dx, 0.0);
      expect(tiltDirection.dy, 0.0);
    });
  });
}
