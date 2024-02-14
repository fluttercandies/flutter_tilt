import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_config.dart';

void main() {
  group('TiltConfig', () {
    test('copyWith', () {
      const TiltConfig tiltConfig = TiltConfig();
      final TiltConfig tiltConfigExpect = TiltConfig(
        disable: true,
        initial: const Offset(1.0, 1.0),
        angle: 1.0,
        direction: [TiltDirection.top, TiltDirection.bottom],
        enableReverse: true,
        filterQuality: FilterQuality.high,
        enableGestureSensors: false,
        sensorFactor: 2.0,
        enableSensorRevert: false,
        sensorRevertFactor: 1.0,
        sensorMoveDuration: Duration.zero,
        enableGestureHover: false,
        enableGestureTouch: false,
        enableRevert: false,
        enableOutsideAreaMove: false,
        moveDuration: Duration.zero,
        leaveDuration: Duration.zero,
        moveCurve: Curves.bounceIn,
        leaveCurve: Curves.bounceIn,
        controllerMoveDuration: Duration.zero,
        controllerLeaveDuration: Duration.zero,
      );
      final TiltConfig tiltConfigCopyWith = tiltConfig.copyWith(
        disable: true,
        initial: const Offset(1.0, 1.0),
        angle: 1.0,
        direction: [TiltDirection.top, TiltDirection.bottom],
        enableReverse: true,
        filterQuality: FilterQuality.high,
        enableGestureSensors: false,
        sensorFactor: 2.0,
        enableSensorRevert: false,
        sensorRevertFactor: 1.0,
        sensorMoveDuration: Duration.zero,
        enableGestureHover: false,
        enableGestureTouch: false,
        enableRevert: false,
        enableOutsideAreaMove: false,
        moveDuration: Duration.zero,
        leaveDuration: Duration.zero,
        moveCurve: Curves.bounceIn,
        leaveCurve: Curves.bounceIn,
        controllerMoveDuration: Duration.zero,
        controllerLeaveDuration: Duration.zero,
      );
      expect(tiltConfig, tiltConfig.copyWith());
      expect(tiltConfigCopyWith, tiltConfigExpect);
      expect(tiltConfigCopyWith.hashCode, tiltConfigExpect.hashCode);
    });
  });
  group('TiltDirection', () {
    test('value', () {
      final TiltDirection tiltDirection = -const TiltDirection(1.0, 1.0);
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
