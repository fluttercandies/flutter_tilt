import 'dart:math';

import 'package:flutter/material.dart';

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

/// 光
class Light extends StatelessWidget {
  /// 光
  ///
  /// 作用于其他组件上的发光效果，
  ///
  /// 搭配 [Stack] 于同级组件上方使用。
  ///
  /// [width], [height] 一般和同级组件尺寸一致
  ///
  /// [position] 触发的位置坐标
  ///
  /// [lightDirection] 发光方向
  const Light({
    super.key,
    required this.width,
    required this.height,
    required this.position,
    required this.lightDirection,
  });

  final double width;
  final double height;

  /// 位置坐标
  final Offset position;

  /// 发光方向
  final LightDirection lightDirection;

  /// 坐标位置 x
  double get x => position.dx;

  /// 坐标位置 y
  double get y => position.dy;

  /// 尺寸 width
  double get w => width;

  /// 尺寸 height
  double get h => height;

  /// 尺寸扩大的倍数
  double get em => 2;

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
    return Positioned(
      left: xPositioned,
      top: yPositioned,
      width: wEm,
      height: hEm,
      child: Opacity(
        opacity: opacity(lightDirection),
        child: Container(
          width: wEm,
          height: hEm,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 0.5,
              colors: [
                Colors.white.withAlpha(60),
                Colors.white.withAlpha(0),
              ],
              stops: const [0.01, 0.99],
              tileMode: TileMode.clamp,
            ),
          ),
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
        // 两点间的距离，sqrt((x1-x2)²+(y1-y2)²)
        // 中心 (x1=0, y1=0) 到坐标 (x2=?, y2=?) 的位置
        final double distance =
            sqrt(tempRotateX * tempRotateX + tempRotateY * tempRotateY);
        opacity = distance * 2;
      case LightDirection.all:
        opacity = 1;
      case LightDirection.top:
        opacity = rotateY * 2;
      case LightDirection.bottom:
        opacity = -rotateY * 2;
      case LightDirection.left:
        opacity = -rotateX * 2;
      case LightDirection.right:
        opacity = rotateX * 2;
      case LightDirection.center:
        // 两点间的距离，sqrt((x1-x2)²+(y1-y2)²)
        // 中心 (x1=0, y1=0) 到坐标 (x2=?, y2=?) 的位置
        final double distance =
            sqrt(tempRotateX * tempRotateX + tempRotateY * tempRotateY);
        opacity = 1 - distance;
      case LightDirection.topLeft:
        opacity = -(rotateX - rotateY) * 2;
      case LightDirection.topRight:
        opacity = (rotateX + rotateY) * 2;
      case LightDirection.bottomLeft:
        opacity = -(rotateX + rotateY) * 2;
      case LightDirection.bottomRight:
        opacity = (rotateX - rotateY) * 2;
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
