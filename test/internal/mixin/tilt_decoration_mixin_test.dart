import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/internal/mixin/tilt_decoration_mixin.dart';

void main() {
  group('TiltDecorationMixin ::', () {
    final tiltDecorationTest = TiltDecorationTest();
    final tiltDecorationDirectionIntensity =
        tiltDecorationTest.tiltDecorationDirectionIntensity;
    test('tiltDecorationDirectionIntensity', () {
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, 1.0),
          LightDirection.bottom,
        ),
        1.0,
        reason: '合法的 LightDirection',
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, -1.0),
          LightDirection.bottom,
        ),
        0.0,
        reason: '不合法的 LightDirection',
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
        ),
        1.0,
        reason: '合法的 ShadowDirection',
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, 1.0),
          ShadowDirection.bottom,
        ),
        0.0,
        reason: '不合法的 ShadowDirection',
      );
    });
    test('tiltDecorationDirectionIntensity LightDirection', () {
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          LightDirection.none,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          LightDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          LightDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, -1.0),
          LightDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          LightDirection.around,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          LightDirection.around,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, -1.0),
          LightDirection.around,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, -1.0),
          LightDirection.top,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, 1.0),
          LightDirection.bottom,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, 0.0),
          LightDirection.left,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 0.0),
          LightDirection.right,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          LightDirection.center,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          LightDirection.center,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, -1.0),
          LightDirection.topLeft,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, -1.0),
          LightDirection.topRight,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, 1.0),
          LightDirection.bottomLeft,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          LightDirection.bottomRight,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, 0.0),
          LightDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          LightDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 0.0),
          LightDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          LightDirection.xCenter,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, -1.0),
          LightDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          LightDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, 1.0),
          LightDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          LightDirection.yCenter,
        ),
        0.0,
      );
    });
    test('tiltDecorationDirectionIntensity ShadowDirection', () {
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          ShadowDirection.none,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          ShadowDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          ShadowDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, -1.0),
          ShadowDirection.all,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          ShadowDirection.around,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          ShadowDirection.around,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, -1.0),
          ShadowDirection.around,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, 1.0),
          ShadowDirection.top,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 0.0),
          ShadowDirection.left,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, 0.0),
          ShadowDirection.right,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          ShadowDirection.center,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          ShadowDirection.center,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          ShadowDirection.topLeft,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, 1.0),
          ShadowDirection.topRight,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, -1.0),
          ShadowDirection.bottomLeft,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, -1.0),
          ShadowDirection.bottomRight,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(-1.0, 0.0),
          ShadowDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          ShadowDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 0.0),
          ShadowDirection.xCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          ShadowDirection.xCenter,
        ),
        0.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, -1.0),
          ShadowDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          ShadowDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, 1.0),
          ShadowDirection.yCenter,
        ),
        1.0,
      );
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          ShadowDirection.yCenter,
        ),
        0.0,
      );
    });
    test('tiltDecorationDirectionIntensity min-max mapping', () {
      /// 强度 0 → min，强度 1 → max，中间线性映射

      /// 强度 1（满）→ max
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          LightDirection.all,
          min: 0.2,
          max: 0.8,
        ),
        0.8,
      );

      /// 强度 0（无）→ min
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          LightDirection.none,
          min: 0.2,
          max: 0.8,
        ),
        0.2,
      );

      /// 负向强度被截断到 0 → min
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, -1.0),
          LightDirection.bottom,
          min: 0.2,
          max: 0.8,
        ),
        0.2,
      );

      /// 正向满强度 → max
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, 1.0),
          LightDirection.bottom,
          min: 0.2,
          max: 0.8,
        ),
        0.8,
      );

      /// 中间强度 0.5 → min + 0.5 * (max - min)
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, 0.5),
          LightDirection.bottom,
          min: 0.2,
          max: 0.8,
        ),
        closeTo(0.5, 1e-10),
      );

      /// 中心方向：正中心强度 1 → max
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          LightDirection.center,
          min: 0.2,
          max: 0.8,
        ),
        0.8,
      );

      /// around 方向：正中心强度 0 → min
      expect(
        tiltDecorationDirectionIntensity(
          Offset.zero,
          LightDirection.around,
          min: 0.2,
          max: 0.8,
        ),
        0.2,
      );

      /// around 方向：距离超出对角线被截断到 1 → max
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(1.0, 1.0),
          LightDirection.around,
          min: 0.2,
          max: 0.8,
        ),
        0.8,
      );

      /// around 方向：中间距离 0.5 → min + 0.5 * (max - min)
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, 0.5),
          LightDirection.around,
          min: 0.2,
          max: 0.8,
        ),
        closeTo(0.5, 1e-10),
      );

      /// 阴影方向和光照方向的 min-max 映射一致，只是强度计算是反向的
      expect(
        tiltDecorationDirectionIntensity(
          const Offset(0.0, -1.0),
          ShadowDirection.bottom,
          min: 0.3,
          max: 0.9,
        ),
        closeTo(0.9, 1e-10),
      );
    });
  });
}

class TiltDecorationTest with TiltDecorationMixin {}
