import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:flutter_tilt/src/utils.dart';

void main() {
  group('utils', () {
    test('sensorsPlatformSupport', () {
      expect(sensorsPlatformSupport(), false);
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

    test('tiltTransform', () {
      expect(
        tiltTransform(100, 100, const Offset(1, 1), 10, false),
        Matrix4(
          0.984807753012208,
          -0.030153689607045803,
          0.17101007166283433,
          0.0008550503583141717,
          0.0,
          0.984807753012208,
          0.17364817766693033,
          0.0008682408883346517,
          -0.17364817766693033,
          -0.17101007166283433,
          0.9698463103929541,
          0.004849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
        reason: 'enableReverse = false',
      );
      expect(
        tiltTransform(100, 100, const Offset(1, 1), 10, true),
        Matrix4(
          0.984807753012208,
          -0.030153689607045803,
          -0.17101007166283433,
          -0.0008550503583141717,
          0.0,
          0.984807753012208,
          -0.17364817766693033,
          -0.0008682408883346517,
          0.17364817766693033,
          0.17101007166283433,
          0.9698463103929541,
          0.004849231551964771,
          0.0,
          0.0,
          0.0,
          1.0,
        ),
        reason: 'enableReverse = true',
      );
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
    test('directionProgress', () {
      /// enableReverse = false
      expect(
        directionProgress<LightDirection>(
          const Offset(0.0, 1.0),
          LightDirection.bottom,
        ),
        1.0,
        reason: '合法的 LightDirection',
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(0.0, -1.0),
          LightDirection.bottom,
        ),
        0.0,
        reason: '不合法的 LightDirection',
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
        ),
        1.0,
        reason: '合法的 ShadowDirection',
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(0.0, 1.0),
          ShadowDirection.bottom,
        ),
        0.0,
        reason: '不合法的 ShadowDirection',
      );

      /// enableReverse = true
      expect(
        directionProgress<LightDirection>(
          const Offset(0.0, -1.0),
          LightDirection.bottom,
          enableReverse: true,
        ),
        1.0,
        reason: '合法的 LightDirection',
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(0.0, 1.0),
          LightDirection.bottom,
          enableReverse: true,
        ),
        0.0,
        reason: '不合法的 LightDirection',
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(0.0, 1.0),
          ShadowDirection.bottom,
          enableReverse: true,
        ),
        1.0,
        reason: '合法的 ShadowDirection',
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
          enableReverse: true,
        ),
        0.0,
        reason: '不合法的 ShadowDirection',
      );
    });
    test('directionProgress LightDirection', () {
      expect(
        directionProgress<LightDirection>(
          const Offset(1.0, 1.0),
          LightDirection.none,
        ),
        0.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(1.0, 1.0),
          LightDirection.all,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          Offset.zero,
          LightDirection.all,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(-1.0, -1.0),
          LightDirection.all,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(1.0, 1.0),
          LightDirection.around,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          Offset.zero,
          LightDirection.around,
        ),
        0.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(-1.0, -1.0),
          LightDirection.around,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(0.0, -1.0),
          LightDirection.top,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(0.0, 1.0),
          LightDirection.bottom,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(-1.0, 0.0),
          LightDirection.left,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(1.0, 0.0),
          LightDirection.right,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          Offset.zero,
          LightDirection.center,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(1.0, 1.0),
          LightDirection.center,
        ),
        0.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(-1.0, -1.0),
          LightDirection.topLeft,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(1.0, -1.0),
          LightDirection.topRight,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(-1.0, 1.0),
          LightDirection.bottomLeft,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(1.0, 1.0),
          LightDirection.bottomRight,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(-1.0, 0.0),
          LightDirection.xCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          Offset.zero,
          LightDirection.xCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(1.0, 0.0),
          LightDirection.xCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(1.0, 1.0),
          LightDirection.xCenter,
        ),
        0.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(0.0, -1.0),
          LightDirection.yCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          Offset.zero,
          LightDirection.yCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(0.0, 1.0),
          LightDirection.yCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<LightDirection>(
          const Offset(1.0, 1.0),
          LightDirection.yCenter,
        ),
        0.0,
      );
    });
    test('directionProgress ShadowDirection', () {
      expect(
        directionProgress<ShadowDirection>(
          const Offset(1.0, 1.0),
          ShadowDirection.none,
        ),
        0.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(1.0, 1.0),
          ShadowDirection.all,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          Offset.zero,
          ShadowDirection.all,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(-1.0, -1.0),
          ShadowDirection.all,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(1.0, 1.0),
          ShadowDirection.around,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          Offset.zero,
          ShadowDirection.around,
        ),
        0.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(-1.0, -1.0),
          ShadowDirection.around,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(0.0, 1.0),
          ShadowDirection.top,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(1.0, 0.0),
          ShadowDirection.left,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(-1.0, 0.0),
          ShadowDirection.right,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          Offset.zero,
          ShadowDirection.center,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(1.0, 1.0),
          ShadowDirection.center,
        ),
        0.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(1.0, 1.0),
          ShadowDirection.topLeft,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(-1.0, 1.0),
          ShadowDirection.topRight,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(1.0, -1.0),
          ShadowDirection.bottomLeft,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(-1.0, -1.0),
          ShadowDirection.bottomRight,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(-1.0, 0.0),
          ShadowDirection.xCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          Offset.zero,
          ShadowDirection.xCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(1.0, 0.0),
          ShadowDirection.xCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(1.0, 1.0),
          ShadowDirection.xCenter,
        ),
        0.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(0.0, -1.0),
          ShadowDirection.yCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          Offset.zero,
          ShadowDirection.yCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(0.0, 1.0),
          ShadowDirection.yCenter,
        ),
        1.0,
      );
      expect(
        directionProgress<ShadowDirection>(
          const Offset(1.0, 1.0),
          ShadowDirection.yCenter,
        ),
        0.0,
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

    test('tiltTweenAnimationEnd', () {
      const tiltConfig = TiltConfig();
      const Offset areaProgress = Offset(1.0, 1.0);
      expect(
        tiltTweenAnimationEnd(false, tiltConfig, areaProgress),
        tiltConfig.initial ?? Offset.zero,
      );
      expect(
        tiltTweenAnimationEnd(
          false,
          const TiltConfig(enableRevert: false),
          areaProgress,
        ),
        areaProgress,
      );
      expect(
        tiltTweenAnimationEnd(
          false,
          const TiltConfig(initial: Offset(0.5, 0.5)),
          areaProgress,
        ),
        const Offset(0.5, 0.5),
      );
    });

    test('tiltTweenAnimationDuration', () {
      const tiltConfig = TiltConfig();
      expect(
        tiltTweenAnimationDuration(false, GesturesType.none, tiltConfig),
        Duration.zero,
      );
      expect(
        tiltTweenAnimationDuration(true, GesturesType.none, tiltConfig),
        Duration.zero,
      );
      expect(
        tiltTweenAnimationDuration(false, GesturesType.touch, tiltConfig),
        tiltConfig.leaveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, GesturesType.touch, tiltConfig),
        tiltConfig.moveDuration,
      );
      expect(
        tiltTweenAnimationDuration(false, GesturesType.hover, tiltConfig),
        tiltConfig.leaveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, GesturesType.hover, tiltConfig),
        tiltConfig.moveDuration,
      );
      expect(
        tiltTweenAnimationDuration(false, GesturesType.sensors, tiltConfig),
        tiltConfig.sensorMoveDuration,
      );
      expect(
        tiltTweenAnimationDuration(true, GesturesType.sensors, tiltConfig),
        tiltConfig.sensorMoveDuration,
      );
    });

    test('tiltTweenAnimationCurve', () {
      const tiltConfig = TiltConfig();
      expect(
        tiltTweenAnimationCurve(false, GesturesType.none, tiltConfig),
        Curves.linear,
      );
      expect(
        tiltTweenAnimationCurve(true, GesturesType.none, tiltConfig),
        Curves.linear,
      );
      expect(
        tiltTweenAnimationCurve(false, GesturesType.touch, tiltConfig),
        tiltConfig.leaveCurve,
      );
      expect(
        tiltTweenAnimationCurve(true, GesturesType.touch, tiltConfig),
        tiltConfig.moveCurve,
      );
      expect(
        tiltTweenAnimationCurve(false, GesturesType.hover, tiltConfig),
        tiltConfig.leaveCurve,
      );
      expect(
        tiltTweenAnimationCurve(true, GesturesType.hover, tiltConfig),
        tiltConfig.moveCurve,
      );
      expect(
        tiltTweenAnimationCurve(false, GesturesType.sensors, tiltConfig),
        Curves.linear,
      );
      expect(
        tiltTweenAnimationCurve(true, GesturesType.sensors, tiltConfig),
        Curves.linear,
      );
    });
  });
}
