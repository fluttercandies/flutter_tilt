import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/internal/mixin/tilt_decoration_mixin.dart';

void main() {
  group('TiltDecorationMixin ::', () {
    final tiltDecorationTest = TiltDecorationTest();
    final tiltDecorationDirectionProgress =
        tiltDecorationTest.tiltDecorationDirectionProgress;
    test('tiltDecorationDirectionProgress', () {
      /// enableReverse = false
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, 1.0),
          LightDirection.bottom,
        ),
        1.0,
        reason: '合法的 LightDirection',
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, -1.0),
          LightDirection.bottom,
        ),
        0.0,
        reason: '不合法的 LightDirection',
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
        ),
        1.0,
        reason: '合法的 ShadowDirection',
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, 1.0),
          ShadowDirection.bottom,
        ),
        0.0,
        reason: '不合法的 ShadowDirection',
      );

      /// enableReverse = true
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, -1.0),
          LightDirection.bottom,
          enableReverse: true,
        ),
        1.0,
        reason: '合法的 LightDirection',
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, 1.0),
          LightDirection.bottom,
          enableReverse: true,
        ),
        0.0,
        reason: '不合法的 LightDirection',
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, 1.0),
          ShadowDirection.bottom,
          enableReverse: true,
        ),
        1.0,
        reason: '合法的 ShadowDirection',
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
          enableReverse: true,
        ),
        0.0,
        reason: '不合法的 ShadowDirection',
      );
    });
    test('tiltDecorationDirectionProgress LightDirection', () {
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          LightDirection.none,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          LightDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          Offset.zero,
          LightDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, -1.0),
          LightDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          LightDirection.around,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          Offset.zero,
          LightDirection.around,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, -1.0),
          LightDirection.around,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, -1.0),
          LightDirection.top,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, 1.0),
          LightDirection.bottom,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, 0.0),
          LightDirection.left,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 0.0),
          LightDirection.right,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          Offset.zero,
          LightDirection.center,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          LightDirection.center,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, -1.0),
          LightDirection.topLeft,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, -1.0),
          LightDirection.topRight,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, 1.0),
          LightDirection.bottomLeft,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          LightDirection.bottomRight,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, 0.0),
          LightDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          Offset.zero,
          LightDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 0.0),
          LightDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          LightDirection.xCenter,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, -1.0),
          LightDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          Offset.zero,
          LightDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, 1.0),
          LightDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          LightDirection.yCenter,
        ),
        0.0,
      );
    });
    test('tiltDecorationDirectionProgress ShadowDirection', () {
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          ShadowDirection.none,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          ShadowDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          Offset.zero,
          ShadowDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, -1.0),
          ShadowDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          ShadowDirection.around,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          Offset.zero,
          ShadowDirection.around,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, -1.0),
          ShadowDirection.around,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, 1.0),
          ShadowDirection.top,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 0.0),
          ShadowDirection.left,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, 0.0),
          ShadowDirection.right,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          Offset.zero,
          ShadowDirection.center,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          ShadowDirection.center,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          ShadowDirection.topLeft,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, 1.0),
          ShadowDirection.topRight,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, -1.0),
          ShadowDirection.bottomLeft,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, -1.0),
          ShadowDirection.bottomRight,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(-1.0, 0.0),
          ShadowDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          Offset.zero,
          ShadowDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 0.0),
          ShadowDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          ShadowDirection.xCenter,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, -1.0),
          ShadowDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          Offset.zero,
          ShadowDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(0.0, 1.0),
          ShadowDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionProgress(
          const Offset(1.0, 1.0),
          ShadowDirection.yCenter,
        ),
        0.0,
      );
    });
  });
}

class TiltDecorationTest with TiltDecorationMixin {}
