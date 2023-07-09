import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';

/// 光源方向
enum LightDirection {
  /// 禁用光源
  none,

  /// 周围光源，距离周围越近越亮，距离中心越近越暗。
  around,

  /// 整体光源相同，所有坐标位置光源亮度一致。
  all,

  /// 仅顶部光源
  top,

  /// 仅底部光源
  bottom,

  /// 仅左侧光源
  left,

  /// 仅右侧光源
  right,

  /// 中心光源，距离中心越近越亮，距离中心越远越暗。
  center,

  /// 仅左上光源
  topLeft,

  /// 仅右上光源
  topRight,

  /// 仅左下光源
  bottomLeft,

  /// 仅右下光源
  bottomRight,

  /// 仅 x 轴中心光源
  xCenter,

  /// 仅 y 轴中心光源
  yCenter,
}

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
    required this.lightDirection,
    required this.islightReverse,
  });

  final double width;
  final double height;

  /// 位置坐标
  final Offset position;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 光颜色
  final Color lightColor;

  /// 光源方向
  final LightDirection lightDirection;

  /// 光源是否反向
  final bool islightReverse;

  /// 坐标位置 x
  double get x => position.dx;

  /// 坐标位置 y
  double get y => position.dy;

  /// 尺寸 width
  double get w => width;

  /// 尺寸 height
  double get h => height;

  /// 尺寸扩大的倍数
  double get em => 4;

  /// 扩大的尺寸 width
  double get wEm => w * em;

  /// 扩大的尺寸 height
  double get hEm => h * em;

  /// 定位 x （从组件中心位置开始）
  double get xPositioned => x - w / 2 * em;

  /// 定位 y （从组件中心位置开始）
  double get yPositioned => y - h / 2 * em;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: islightReverse ? xPositioned : null,
      top: islightReverse ? yPositioned : null,
      right: !islightReverse ? xPositioned : null,
      bottom: !islightReverse ? yPositioned : null,
      child: Opacity(
        opacity: opacity(lightDirection),
        child: Container(
          width: wEm,
          height: hEm,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 0.5,
              colors: [
                lightColor.withAlpha(80),
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

  /// 透明度计算
  double opacity(LightDirection lightDirection) {
    /// 旋转角度 (中心位置) / 灵敏度
    final double rotateX = -((w / 2 - x) / w);
    final double rotateY = ((h / 2 - y) / h);

    print("opacity");
    print(rotateX);
    print(rotateY);

    /// 临时位置
    late double tempRotateX = rotateX;
    late double tempRotateY = rotateY;

    /// 透明度
    late double opacity = 0;

    switch (lightDirection) {
      case LightDirection.none:
      case LightDirection.around:
        final double distance =
            p2pDistance(Offset.zero, Offset(tempRotateX, tempRotateY));
        opacity = distance * 2;
      case LightDirection.all:
        opacity = 1;
      case LightDirection.top:
        opacity = -rotateY * 2;
      case LightDirection.bottom:
        opacity = rotateY * 2;
      case LightDirection.left:
        opacity = rotateX * 2;
      case LightDirection.right:
        opacity = -rotateX * 2;
      case LightDirection.center:
        final double distance =
            p2pDistance(Offset.zero, Offset(tempRotateX, tempRotateY));
        opacity = 1 - distance;
      case LightDirection.topLeft:
        opacity = (rotateX - rotateY) * 2;
      case LightDirection.bottomRight:
        opacity = -(rotateX - rotateY) * 2;
      case LightDirection.topRight:
        opacity = -(rotateX + rotateY) * 2;
      case LightDirection.bottomLeft:
        opacity = (rotateX + rotateY) * 2;
      case LightDirection.xCenter:
        if (rotateY < 0) tempRotateY = -rotateY;
        opacity = 1 - tempRotateY;
      case LightDirection.yCenter:
        if (rotateX < 0) tempRotateX = -rotateX;
        opacity = 1 - tempRotateX;
    }

    /// 避免超出范围
    if (opacity < 0) opacity = 0;
    if (opacity > 1) opacity = 1;

    return opacity;
  }
}
