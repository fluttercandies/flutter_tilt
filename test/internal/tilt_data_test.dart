import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_config.dart';
import 'package:flutter_tilt/src/internal/tilt_data.dart';

void main() {
  group('TiltData ::', () {
    test('tiltTransform', () {
      expect(
        const TiltData(
          width: 100,
          height: 100,
          isInit: true,
          areaProgress: Offset(1.0, 1.0),
          tiltConfig: TiltConfig(
            angle: 10.0,
            enableReverse: false,
          ),
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
        const TiltData(
          width: 100,
          height: 100,
          isInit: true,
          areaProgress: Offset(1.0, 1.0),
          tiltConfig: TiltConfig(
            angle: 10.0,
            enableReverse: true,
          ),
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
  });
}
