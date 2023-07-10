import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';

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
    required this.shadowDistance,
    required this.shadowSpreadRadius,
    required this.shadowBlurRadius,
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

  /// 阴影距离
  final double shadowDistance;

  /// 阴影扩散半径
  final double shadowSpreadRadius;

  /// 阴影模糊半径
  final double shadowBlurRadius;

  /// 当前坐标相对于中心坐标的区域坐标
  Offset get p2cPostion => -p2cAreaPostion(width, height, position);

  /// 当前坐标在中心坐标到区域边界的进度
  Offset get p2cProgress => p2cAreaProgress(width, height, position);

  /// 距离中心的进度
  double get centerDistance => p2pDistance(Offset.zero, p2cProgress);

  /// 阴影当前坐标
  ///
  /// 阴影坐标 * 阴影距离
  Offset get offset => p2cPostion * shadowDistance;

  /// 阴影模糊半径
  ///
  /// 距离中心的进度 * 模糊半径 * 阴影距离
  double get blurRadius => centerDistance * shadowBlurRadius * shadowDistance;

  /// 阴影扩散半径
  ///
  /// (距离中心的进度 * 扩散半径 * 阴影距离) - (固定扩散值 * shadowDistance)
  double get spreadRadius =>
      (centerDistance * shadowSpreadRadius * shadowDistance) -
      ((width < height ? width : height) / 10 * shadowDistance);

  /// 阴影颜色
  ///
  /// 距离中心的进度 * ColorAlpha
  int get colorAlpha => (centerDistance * 60).toInt();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor.withAlpha(colorAlpha > 255 ? 255 : colorAlpha),
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
