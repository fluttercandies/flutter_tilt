import 'package:flutter/widgets.dart';

import 'utils.dart';

/// 阴影
class TiltShadow extends StatelessWidget {
  /// 阴影
  ///
  /// 作用于其他组件上的阴影效果，
  ///
  /// [width], [height] 一般和传入的组件尺寸一致
  const TiltShadow({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.position,
    this.borderRadius,
    required this.shadowColor,
  });

  final Widget child;
  final double width;
  final double height;

  /// 位置坐标
  final Offset position;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 阴影颜色
  final Color shadowColor;

  /// 尺寸 width
  double get w => width;

  /// 尺寸 height
  double get h => height;

  /// 坐标位置 x
  double get x => position.dx;

  /// 坐标位置 y
  double get y => position.dy;

  /// 定位 x （从组件中心位置开始）
  double get xPositioned => x - w / 2;

  /// 定位 y （从组件中心位置开始）
  double get yPositioned => y - h / 2;

  /// 速度
  double get speed => 4;

  /// Shadow Offset
  Offset get offset => Offset(xPositioned, yPositioned) / speed;

  /// 距离中心
  double get centerDistance =>
      p2pDistance(Offset.zero, Offset(xPositioned, yPositioned));

  /// Shadow BlurRadius
  double get blurRadius =>
      p2pDistance(Offset.zero, Offset(xPositioned, yPositioned)) / speed;

  /// Shadow SpreadRadius
  ///
  /// (扩散半径) - (最短边/10)
  double get spreadRadius =>
      ((centerDistance / speed) / 2) - (w < h ? w / 10 : h / 10);

  /// Shadow Color
  ///
  /// 距离中心坐标的百分比 * 60 Alpha
  int get colorAlpha => ((centerDistance * 2 / (w < h ? h : w)) * 60).toInt();

  @override
  Widget build(BuildContext context) {
    print('Shadow Build');
    print(colorAlpha);
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor.withAlpha(
              colorAlpha > 255 ? 255 : colorAlpha,
            ),
            offset: offset,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            blurStyle: BlurStyle.normal,
          ),
        ],
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
