import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/enums.dart';
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
  const TiltLight({
    Key? key,
    required this.width,
    required this.height,
    required this.position,
    this.borderRadius,
    required this.lightConfig,
  }) : super(key: key);

  final double width;
  final double height;

  /// 当前坐标
  final Offset position;

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
  Offset get p2cPostion => -p2cAreaPostion(spreadW, spreadH, position);

  /// 定位 x （从中心位置开始）
  double get postionX => p2cPostion.dx;

  /// 定位 y （从中心位置开始）
  double get postionY => p2cPostion.dy;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: lightConfig.isReverse ? postionX : null,
      top: lightConfig.isReverse ? postionY : null,
      right: !lightConfig.isReverse ? postionX : null,
      bottom: !lightConfig.isReverse ? postionY : null,
      child: Opacity(
        opacity: lightSource(lightConfig.direction),
        child: Container(
          width: spreadW,
          height: spreadH,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 0.5,
              colors: [
                lightConfig.color.withAlpha(lightConfig.intensity),
                lightConfig.color.withAlpha(0),
              ],
              stops: const [0.01, 0.99],
              tileMode: TileMode.clamp,
            ),
            borderRadius: borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
        ),
      ),
    );
  }

  /// 光源计算
  double lightSource(LightDirection lightDirection) {
    /// 光源：区域进度
    final Offset progress = -p2cAreaProgress(width, height, position);
    final double progressX = progress.dx, progressY = progress.dy;

    /// 临时区域进度
    late double tempX = progressX, tempY = progressY;

    /// 透明度
    late double opacity = 0;

    switch (lightDirection) {
      case LightDirection.none:
        break;
      case LightDirection.around:
        final double distance = p2pDistance(Offset.zero, Offset(tempX, tempY));
        opacity = distance;
        break;
      case LightDirection.all:
        opacity = lightConfig.intensity.toDouble();
        break;
      case LightDirection.top:
        opacity = progressY;
        break;
      case LightDirection.bottom:
        opacity = -progressY;
        break;
      case LightDirection.left:
        opacity = progressX;
        break;
      case LightDirection.right:
        opacity = -progressX;
        break;
      case LightDirection.center:
        final double distance = p2pDistance(Offset.zero, Offset(tempX, tempY));
        opacity = lightConfig.intensity - distance;
        break;
      case LightDirection.topLeft:
        opacity = (progressX + progressY);
        break;
      case LightDirection.bottomRight:
        opacity = -(progressX + progressY);
        break;
      case LightDirection.topRight:
        opacity = -(progressX - progressY);
        break;
      case LightDirection.bottomLeft:
        opacity = (progressX - progressY);
        break;
      case LightDirection.xCenter:
        if (progressY < 0) tempY = -progressY;
        opacity = lightConfig.intensity - tempY;
        break;
      case LightDirection.yCenter:
        if (progressX < 0) tempX = -progressX;
        opacity = lightConfig.intensity - tempX;
        break;
    }

    /// 避免超出范围
    if (opacity < 0) opacity = 0;
    if (opacity > 1) opacity = 1;

    return opacity;
  }
}
