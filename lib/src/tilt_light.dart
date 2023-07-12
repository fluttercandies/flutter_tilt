import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';

/// 光源
class TiltLight extends StatelessWidget {
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
    Key? key,
    required this.width,
    required this.height,
    required this.position,
    required this.areaProgress,
    this.borderRadius,
    required this.lightConfig,
  }) : super(key: key);

  final double width;
  final double height;

  /// 当前坐标
  final Offset position;

  /// 当前坐标的区域进度
  final Offset areaProgress;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 光源配置
  final LightConfig lightConfig;

  /// 尺寸扩散的倍数
  double get spread => 4;

  /// 扩散的尺寸 width
  double get spreadW => width * spread;

  /// 扩散的尺寸 height
  double get spreadH => height * spread;

  /// 当前坐标相对于中心坐标的区域坐标
  Offset get p2cPosition => -p2cAreaPosition(
        spreadW,
        spreadH,
        position,
      );

  /// 定位 x （从中心位置开始）
  double get positionX => p2cPosition.dx;

  /// 定位 y （从中心位置开始）
  double get positionY => p2cPosition.dy;

  /// 光源方向进度
  double get showProgress => directionProgress(
        width,
        height,
        areaProgress,
        lightConfig.direction,
        max: lightConfig.intensity,
      );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: lightConfig.isReverse ? positionX : null,
      top: lightConfig.isReverse ? positionY : null,
      right: !lightConfig.isReverse ? positionX : null,
      bottom: !lightConfig.isReverse ? positionY : null,
      child: Container(
        width: spreadW,
        height: spreadH,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 0.5,
            colors: [
              lightConfig.color.withOpacity(showProgress),
              lightConfig.color.withOpacity(0),
            ],
            stops: const [0.01, 0.99],
            tileMode: TileMode.clamp,
          ),
          borderRadius: borderRadius,
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
