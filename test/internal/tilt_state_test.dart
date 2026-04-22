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
