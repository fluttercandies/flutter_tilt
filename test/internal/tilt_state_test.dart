import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_config.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/internal/tilt_state.dart';
import 'package:flutter_tilt/src/utils/utils.dart';

void main() {
  group('TiltState ::', () {
    const tiltState = TiltState(
      width: 100,
      height: 100,
      isInit: true,
      areaProgress: Offset.zero,
      tiltConfig: TiltConfig(
        angle: 10.0,
        enableReverse: false,
      ),
      isActive: false,
      currentGesturesType: GesturesType.none,
    );

    test('hashCode', () {
      final tiltState1 = const TiltState(
        isInit: true,
        tiltConfig: TiltConfig(
          angle: 10.0,
          enableReverse: false,
        ),
        width: 1,
        height: 1,
        areaProgress: Offset.zero,
        isActive: true,
        currentGesturesType: GesturesType.touch,
      );
      final tiltState2 = const TiltState(
        isInit: true,
        tiltConfig: TiltConfig(
          angle: 10.0,
          enableReverse: false,
        ),
        width: 1,
        height: 1,
        areaProgress: Offset.zero,
        isActive: true,
        currentGesturesType: GesturesType.touch,
      );
      expect(tiltState1, tiltState2);
      expect(tiltState1.hashCode, tiltState2.hashCode);
    });

    test('tiltTransform', () {
      expect(
        const TiltState(
          width: 100,
          height: 100,
          isInit: true,
          areaProgress: Offset(1.0, 1.0),
          tiltConfig: TiltConfig(
            angle: 10.0,
            enableReverse: false,
          ),
          isActive: true,
          currentGesturesType: GesturesType.touch,
        ).tiltTransform(),
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
        const TiltState(
          width: 100,
          height: 100,
          isInit: true,
          areaProgress: Offset(1.0, 1.0),
          tiltConfig: TiltConfig(
            angle: 10.0,
            enableReverse: true,
          ),
          isActive: true,
          currentGesturesType: GesturesType.touch,
        ).tiltTransform(),
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

    test('tiltTransformFor - perspectiveIntensity overrides setEntry(3, 2)',
        () {
      const state = TiltState(
        width: 100,
        height: 100,
        isInit: true,
        areaProgress: Offset.zero,
        tiltConfig: TiltConfig(perspectiveIntensity: 0.02),
        isActive: true,
        currentGesturesType: GesturesType.touch,
      );
      final m = state.tiltTransformFor(Offset.zero);
      expect(m.entry(3, 2), 0.02);
      expect(m.entry(0, 0), 1.0);
      expect(m.entry(1, 1), 1.0);
      expect(m.entry(2, 2), 1.0);
      expect(m.entry(3, 3), 1.0);
    });

    test('tiltTransformFor - perspectiveIntensity null falls back to default',
        () {
      const state = TiltState(
        width: 100,
        height: 100,
        isInit: true,
        areaProgress: Offset.zero,
        tiltConfig: TiltConfig(),
        isActive: true,
        currentGesturesType: GesturesType.touch,
      );
      expect(state.tiltTransformFor(Offset.zero).entry(3, 2), 0.5 / 100);
    });

    test('tiltTransformFor - zOffset pivot pair cancels at rest', () {
      const withOffset = TiltState(
        width: 100,
        height: 100,
        isInit: true,
        areaProgress: Offset.zero,
        tiltConfig: TiltConfig(zOffset: 160.0),
        isActive: true,
        currentGesturesType: GesturesType.touch,
      );
      const withoutOffset = TiltState(
        width: 100,
        height: 100,
        isInit: true,
        areaProgress: Offset.zero,
        tiltConfig: TiltConfig(),
        isActive: true,
        currentGesturesType: GesturesType.touch,
      );
      // 静止 (progress = 0) 时，成对 zOffset 精确对消
      expectMatrixCloseTo(
        withOffset.tiltTransformFor(Offset.zero),
        withoutOffset.tiltTransformFor(Offset.zero),
      );
    });

    test('tiltTransformFor - zOffset changes the transform under tilt', () {
      const withOffset = TiltState(
        width: 100,
        height: 100,
        isInit: true,
        areaProgress: Offset.zero,
        tiltConfig: TiltConfig(zOffset: 160.0),
        isActive: true,
        currentGesturesType: GesturesType.touch,
      );
      const withoutOffset = TiltState(
        width: 100,
        height: 100,
        isInit: true,
        areaProgress: Offset.zero,
        tiltConfig: TiltConfig(),
        isActive: true,
        currentGesturesType: GesturesType.touch,
      );
      // 倾斜 (progress != 0) 时支点偏移带来横向摆动
      const progress = Offset(1.0, 0.0);
      expect(
        withOffset.tiltTransformFor(progress),
        isNot(withoutOffset.tiltTransformFor(progress)),
      );
    });

    test('moveTo updates pure interaction fields', () {
      final nextTiltData = tiltState.moveTo(
        const Offset(100, 0),
        GesturesType.touch,
      );

      expect(nextTiltData.areaProgress, const Offset(-1.0, 1.0));
      expect(nextTiltData.isActive, isTrue);
      expect(nextTiltData.currentGesturesType, GesturesType.touch);
      expect(nextTiltData.width, tiltState.width);
      expect(nextTiltData.height, tiltState.height);
    });

    test('resolveRevertPosition respects enableRevert', () {
      expect(
        tiltState.resolveRevertPosition(
          currentPosition: const Offset(20, 30),
          initialAreaProgress: const Offset(0.25, -0.25),
        ),
        Utils.progressPosition(
          tiltState.width,
          tiltState.height,
          const Offset(0.25, -0.25),
        ),
      );

      const nonRevertingTiltData = TiltState(
        width: 100,
        height: 100,
        isInit: true,
        areaProgress: Offset.zero,
        tiltConfig: TiltConfig(enableRevert: false),
        isActive: true,
        currentGesturesType: GesturesType.touch,
      );

      expect(
        nonRevertingTiltData.resolveRevertPosition(
          currentPosition: const Offset(20, 30),
          initialAreaProgress: const Offset(0.25, -0.25),
        ),
        const Offset(20, 30),
      );
    });
  });
}

/// 逐元素比较两个 [Matrix4]（列主序 storage）是否在容差内相等。
void expectMatrixCloseTo(
  Matrix4 actual,
  Matrix4 expected, [
  double epsilon = 1e-12,
]) {
  for (var i = 0; i < 16; i++) {
    expect(
      actual.storage[i],
      closeTo(expected.storage[i], epsilon),
      reason: 'storage[$i] mismatch',
    );
  }
}
