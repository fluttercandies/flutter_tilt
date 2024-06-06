import 'package:flutter/widgets.dart';

import '../config/tilt_light_config.dart';
import '../enums.dart';
import '../internal/tilt_decoration_mixin.dart';
import '../utils.dart';

/// 光源
class TiltLight extends StatelessWidget with TiltDecoration {
  /// 光源
  ///
  /// 作用于其他组件上的光源效果，
  ///
  /// 搭配 [Stack] 于同级组件上方使用。
  ///
  /// [width], [height] 一般和传入的组件尺寸一致
  ///
  /// {@macro tilt.LightConfig}
  const TiltLight({
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

  /// 扩散的尺寸 width
  double get spreadW => width * spread;

  /// 扩散的尺寸 height
  double get spreadH => height * spread;

  /// 当前坐标相对于中心坐标的区域坐标
  Offset get p2cPosition => -Utils.p2cAreaPosition(
        spreadW,
        spreadH,
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
          width: spreadW,
          height: spreadH,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                lightConfig.color.withOpacity(showProgress),
                lightConfig.color.withOpacity(0),
              ],
              stops: const <double>[0.01, 0.99],
            ),
          ),
        ),
      ),
    );
  }
}
