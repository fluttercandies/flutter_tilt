import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/type/tilt_shadow_type.dart';

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
    required this.sensitivity,
    required this.shadowConfig,
  });

  final Widget child;
  final double width;
  final double height;

  /// 位置坐标
  final Offset position;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 倾斜灵敏度
  final double sensitivity;

  /// 阴影配置
  final ShadowConfig shadowConfig;

  /// 当前坐标在中心坐标到区域边界的进度
  Offset get p2cProgress => -p2cAreaProgress(width, height, position);

  /// 距离中心的进度
  double get centerProgress => p2pDistance(Offset.zero, p2cProgress);

  /// 阴影当前坐标
  ///
  /// 阴影进度 * 阴影距离 * 100
  Offset get offset => p2cProgress * shadowConfig.distance * 100;

  /// 阴影模糊半径
  ///
  /// 距离中心的进度 * 模糊半径 * 阴影距离
  double get blurRadius =>
      centerProgress * shadowConfig.blurRadius * shadowConfig.distance;

  /// 阴影扩散半径
  ///
  /// (距离中心的进度 * 扩散半径 * 阴影距离 * (倾斜灵敏度 * 10)) - (固定扩散值)
  double get spreadRadius =>
      (centerProgress *
          shadowConfig.spreadRadius *
          shadowConfig.distance *
          (sensitivity * 10)) -
      ((width < height ? width : height) / 10);

  /// 阴影颜色
  ///
  /// 距离中心的进度 * ColorAlpha
  int get colorAlpha => (centerProgress * 60).toInt();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          if (shadowConfig.distance != 0)
            BoxShadow(
              color: shadowConfig.color
                  .withAlpha(colorAlpha > 255 ? 255 : colorAlpha),
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
