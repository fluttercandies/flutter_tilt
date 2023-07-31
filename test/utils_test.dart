import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:flutter_tilt/src/utils.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('utils', () {
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
        p2cAreaPosition(100, 100, const Offset(100, 100)),
        const Offset(-50.0, -50.0),
      );
    });
    test('p2cAreaProgress', () {
      expect(
        p2cAreaProgress(
          100,
          100,
          const Offset(10, 10),
          <TiltDirection>[const TiltDirection(1, 1)],
        ),
        const Offset(0.8, 0.8),
        reason: '合法的 TiltDirection',
      );
      expect(
        p2cAreaProgress(
          100,
          100,
          const Offset(10, 10),
          <TiltDirection>[const TiltDirection(-1, -1)],
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
          100.0,
          100.0,
          const Offset(0.0, 1.0),
          LightDirection.bottom,
        ),
        1.0,
        reason: '合法的 LightDirection',
      );
      expect(
        directionProgress<LightDirection>(
          100.0,
          100.0,
          const Offset(0.0, -1.0),
          LightDirection.bottom,
        ),
        0.0,
        reason: '不合法的 LightDirection',
      );
      expect(
        directionProgress<ShadowDirection>(
          100.0,
          100.0,
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
        ),
        1.0,
        reason: '合法的 ShadowDirection',
      );
      expect(
        directionProgress<ShadowDirection>(
          100.0,
          100.0,
          const Offset(0.0, 1.0),
          ShadowDirection.bottom,
        ),
        0.0,
        reason: '不合法的 ShadowDirection',
      );

      /// enableReverse = true
      expect(
        directionProgress<LightDirection>(
          100.0,
          100.0,
          const Offset(0.0, -1.0),
          LightDirection.bottom,
          enableReverse: true,
        ),
        1.0,
        reason: '合法的 LightDirection',
      );
      expect(
        directionProgress<LightDirection>(
          100.0,
          100.0,
          const Offset(0.0, 1.0),
          LightDirection.bottom,
          enableReverse: true,
        ),
        0.0,
        reason: '不合法的 LightDirection',
      );
      expect(
        directionProgress<ShadowDirection>(
          100.0,
          100.0,
          const Offset(0.0, 1.0),
          ShadowDirection.bottom,
          enableReverse: true,
        ),
        1.0,
        reason: '合法的 ShadowDirection',
      );
      expect(
        directionProgress<ShadowDirection>(
          100.0,
          100.0,
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
          enableReverse: true,
        ),
        0.0,
        reason: '不合法的 ShadowDirection',
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
