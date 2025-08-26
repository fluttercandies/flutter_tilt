import 'package:flutter/widgets.dart';

import '../config/tilt_light_config.dart';
import '../enums.dart';
import '../internal/mixin/tilt_decoration_mixin.dart';
import '../utils.dart';

/// 光源
class TiltLight extends StatelessWidget with TiltDecorationMixin {
  /// 光源
  ///
  /// 作用于其他组件上的光源效果，
  ///
  /// 搭配 [Stack] 于同级组件上方使用。
  ///
  /// [width], [height] 一般和传入的组件尺寸一致
  ///
  /// {@macro tilt.LightConfig}
  TiltLight({
    super.key,
    required this.width,
    required this.height,
    required this.areaProgress,
    required this.lightConfig,
  });

  final double width, height;

  /// 当前坐标的区域进度
  final Offset areaProgress;

  /// 光源配置
  final LightConfig lightConfig;

  /// 当前坐标
  Offset get position => Utils.progressPosition(width, height, areaProgress);

  /// 尺寸扩散的倍数
  double get spread => lightConfig.spreadFactor;

  /// 当前坐标相对于中心坐标的区域坐标
  Offset get p2cPosition => -Utils.p2cAreaPosition(
        _spreadW,
        _spreadH,
        Utils.constraintsPosition(width, height, position),
      );

  /// 定位 x （从中心位置开始）
  double get positionX => p2cPosition.dx;

  /// 定位 y （从中心位置开始）
  double get positionY => p2cPosition.dy;

  /// 光源方向进度
  double get showProgress => tiltDecorationDirectionProgress(
        areaProgress,
        lightConfig.direction,
        min: lightConfig.minIntensity,
        max: lightConfig.maxIntensity,
      );

  /// 开启反向
  ///
  /// {@macro tilt.LightConfig.enableReverse}
  bool get enableReverse => lightConfig.enableReverse ?? false;

  /// 禁用光源
  bool get lightDisable =>
      lightConfig.disable ||
      lightConfig.maxIntensity == 0.0 ||
      lightConfig.direction == LightDirection.none;

  /// 扩散的尺寸 width
  late final double _spreadW = width * spread;

  /// 扩散的尺寸 height
  late final double _spreadH = height * spread;

  @override
  Widget build(BuildContext context) {
    if (lightDisable) {
      return const SizedBox();
    }

    return Positioned(
      left: enableReverse ? positionX : null,
      top: enableReverse ? positionY : null,
      right: !enableReverse ? positionX : null,
      bottom: !enableReverse ? positionY : null,
      child: IgnorePointer(
        child: Container(
          width: _spreadW,
          height: _spreadH,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              colors: <Color>[
                /// TODO: Flutter v3.27.0 之后需要迁移，在这之前暂时使用 withAlpha，
                /// （目前为了兼容更多低版本 Flutter 以及对于非主要 Tilt 效果的 P3 广色域优先级很低，未来再迁移为 withValues）
                /// 以下 withAlpha 内的计算方式和 withOpacity 内部的计算方式一致，
                /// 所以还不支持 P3 广色域，目前依旧是 sRGB。
                /// https://docs.flutter.dev/release/breaking-changes/wide-gamut-framework
                lightConfig.color.withAlpha((255.0 * showProgress).round()),
                lightConfig.color.withAlpha(0),
              ],
              stops: const <double>[0.01, 0.99],
            ),
          ),
        ),
      ),
    );
  }
}
