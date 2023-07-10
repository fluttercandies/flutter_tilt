import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/enums.dart';

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
    super.key,
    required this.width,
    required this.height,
    required this.position,
    this.borderRadius,
    required this.lightColor,
    required this.lightIntensity,
    required this.lightDirection,
    required this.islightReverse,
  });

  final double width;
  final double height;

  /// 当前坐标
  final Offset position;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 光源颜色
  final Color lightColor;

  /// 光源强度
  ///
  /// min: 0 max: 255
  ///
  /// 为 0 时将没有光源
  final int lightIntensity;

  /// 光源方向
  final LightDirection lightDirection;

  /// 光源是否反向
  final bool islightReverse;

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
      left: islightReverse ? postionX : null,
      top: islightReverse ? postionY : null,
      right: !islightReverse ? postionX : null,
      bottom: !islightReverse ? postionY : null,
      child: Opacity(
        opacity: lightSource(lightDirection),
        child: Container(
          width: spreadW,
          height: spreadH,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 0.5,
              colors: [
                lightColor.withAlpha(lightIntensity),
                lightColor.withAlpha(0),
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
      case LightDirection.around:
        final double distance = p2pDistance(Offset.zero, Offset(tempX, tempY));
        opacity = distance;
      case LightDirection.all:
        opacity = lightIntensity.toDouble();
      case LightDirection.top:
        opacity = progressY;
      case LightDirection.bottom:
        opacity = -progressY;
      case LightDirection.left:
        opacity = progressX;
      case LightDirection.right:
        opacity = -progressX;
      case LightDirection.center:
        final double distance = p2pDistance(Offset.zero, Offset(tempX, tempY));
        opacity = lightIntensity - distance;
      case LightDirection.topLeft:
        opacity = (progressX + progressY);
      case LightDirection.bottomRight:
        opacity = -(progressX + progressY);
      case LightDirection.topRight:
        opacity = -(progressX - progressY);
      case LightDirection.bottomLeft:
        opacity = (progressX - progressY);
      case LightDirection.xCenter:
        if (progressY < 0) tempY = -progressY;
        opacity = lightIntensity - tempY;
      case LightDirection.yCenter:
        if (progressX < 0) tempX = -progressX;
        opacity = lightIntensity - tempX;
    }

    /// 避免超出范围
    if (opacity < 0) opacity = 0;
    if (opacity > 1) opacity = 1;

    return opacity;
  }
}
