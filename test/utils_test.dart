import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:flutter_tilt/src/utils.dart';

void main() {
  group('utils ::', () {
    const sensorsPlatformSupport = Utils.sensorsPlatformSupport;
    const centerPosition = Utils.centerPosition;
    const radian = Utils.radian;
    const p2pDistance = Utils.p2pDistance;
    const rotateAxis = Utils.rotateAxis;
    const p2cAreaPosition = Utils.p2cAreaPosition;
    const p2cAreaProgress = Utils.p2cAreaProgress;
    const progressPosition = Utils.progressPosition;
    const isInRange = Utils.isInRange;
    const constraintsPosition = Utils.constraintsPosition;

    test('sensorsPlatformSupport', () {
      for (final TargetPlatform testTargetPlatform in TargetPlatform.values) {
        debugDefaultTargetPlatformOverride = testTargetPlatform;
        switch (testTargetPlatform) {
          case TargetPlatform.android:
            expect(sensorsPlatformSupport(), true);
          case TargetPlatform.iOS:
            expect(sensorsPlatformSupport(), true);
          case _:
            expect(sensorsPlatformSupport(), false);
        }
        debugDefaultTargetPlatformOverride = null;
      }
    });

    test('centerPosition', () {
      expect(centerPosition(100, 100), const Offset(50.0, 50.0));
      expect(radian(10), 0.17453292519943295);
      expect(p2pDistance(Offset.zero, const Offset(1, 1)), 1.4142135623730951);
    });

    test('radian', () {
      expect(radian(10), 0.17453292519943295);
      expect(p2pDistance(Offset.zero, const Offset(1, 1)), 1.4142135623730951);
    });

    test('p2pDistance', () {
      expect(p2pDistance(Offset.zero, const Offset(1, 1)), 1.4142135623730951);
    });

    test('rotateAxis', () {
      expect(
        rotateAxis(const Offset(1, 1), false),
        const Offset(1.0, -1.0),
        reason: 'enableReverse = false',
      );
      expect(
        rotateAxis(const Offset(1, 1), true),
        const Offset(-1.0, 1.0),
        reason: 'enableReverse = true',
      );
    });
    test('p2cAreaPosition', () {
      expect(
        p2cAreaPosition(100, 100, const Offset(90, 90)),
        const Offset(-40.0, -40.0),
        reason: '合法值',
      );
      expect(
        p2cAreaPosition(100, 100, const Offset(-1, -1)),
        const Offset(50.0, 50.0),
        reason: '超出范围',
      );
      expect(
        p2cAreaPosition(100, 100, const Offset(101, 101)),
        const Offset(-50.0, -50.0),
        reason: '超出范围',
      );
    });
    test('p2cAreaProgress', () {
      expect(
        p2cAreaProgress(
          100,
          100,
          const Offset(10, 10),
          null,
        ),
        const Offset(0.8, 0.8),
        reason: 'TiltDirection = null, 范围内',
      );
      expect(
        p2cAreaProgress(
          100,
          100,
          const Offset(101.0, 101.0),
          null,
        ),
        const Offset(-1.0, -1.0),
        reason: 'TiltDirection = null, 超出范围',
      );
      expect(
        p2cAreaProgress(
          100,
          100,
          const Offset(-1.0, -1.0),
          null,
        ),
        const Offset(1.0, 1.0),
        reason: 'TiltDirection = null, 超出范围',
      );
      expect(
        p2cAreaProgress(
          100,
          100,
          const Offset(50, 10),
          <TiltDirection>[
            const TiltDirection(1, 0),
            const TiltDirection(0, 1),
          ],
        ),
        const Offset(0.0, 0.8),
        reason: '合法的 TiltDirection',
      );
      expect(
        p2cAreaProgress(
          100,
          100,
          const Offset(0, 10),
          <TiltDirection>[
            const TiltDirection(-1, 0),
            const TiltDirection(0, -1),
          ],
        ),
        Offset.zero,
        reason: '不合法的 TiltDirection',
      );
    });
    test('progressPosition', () {
      expect(
        progressPosition(100.0, 100.0, const Offset(-1, -1)),
        const Offset(100.0, 100.0),
      );
    });
    test('isInRange', () {
      expect(isInRange(100.0, 100.0, const Offset(100.0, 100.0)), true);
      expect(isInRange(100.0, 100.0, const Offset(101.0, 101.0)), false);
    });
    test('constraintsPosition', () {
      expect(
        constraintsPosition(1.0, 1.0, const Offset(1.0, 1.0)),
        const Offset(1.0, 1.0),
        reason: '正常范围',
      );
      expect(
        constraintsPosition(1.0, 1.0, const Offset(2.0, 2.0)),
        const Offset(1.0, 1.0),
        reason: '超出最大范围',
      );
      expect(
        constraintsPosition(1.0, 1.0, const Offset(-0.1, -0.1)),
        Offset.zero,
        reason: '超出最小范围',
      );
    });
  });
}
