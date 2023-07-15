import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';
import 'package:flutter_tilt/src/type/tilt_shadow_type.dart';

/// 阴影
class TiltShadow extends StatelessWidget {
  /// 阴影
  ///
  /// 作用于其他组件上的阴影效果
  ///
  /// [width], [height] 一般和传入的组件尺寸一致
  ///
  /// {@macro tilt.ShadowConfig}
  const TiltShadow({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.areaProgress,
    this.borderRadius,
    required this.clipBehavior,
    required this.lightConfig,
    required this.shadowConfig,
  });

  final Widget child;
  final double width, height;

  /// 当前坐标的区域进度
  final Offset areaProgress;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// Clip
  final Clip clipBehavior;

  /// 光源配置
  final LightConfig lightConfig;

  /// 阴影配置
  final ShadowConfig shadowConfig;

  /// 当前坐标的区域进度
  Offset get progress => -areaProgress;

  /// 距离中心的进度
  double get centerProgress => p2pDistance(Offset.zero, progress);

  /// 阴影显示（受光源影响）
  ///
  /// 用于阴影颜色，限制最大进度表示强度（透明度）
  ///
  /// {@macro tilt.ShadowConfig.direction}
  double get showShadow => directionProgress(
        width,
        height,
        areaProgress,
        shadowConfig.direction ?? lightConfig.direction,
        max: shadowConfig.intensity,
      );

  /// 阴影当前偏移距离
  ///
  /// 阴影进度 * 阴影偏移系数的距离（相对当前尺寸的中心）
  Offset get offset =>
      progress *
      p2pDistance(
        centerPosition(width, height),
        centerPosition(width, height) * (shadowConfig.offsetFactor + 1),
      );

  /// 阴影模糊半径
  ///
  /// 距离中心的进度 * 模糊半径
  double get blurRadius => centerProgress * shadowConfig.blurRadius;

  /// 阴影扩散半径距离
  ///
  /// (距离中心的进度 * 阴影扩散系数)
  double get spreadRadiusDistance => p2pDistance(
        Offset(width, height),
        Offset(width, height) * (shadowConfig.spreadFactor + 1),
      );

  /// 阴影扩散半径距离还原
  ///
  /// 避免初始状态的扩散
  ///
  /// (阴影扩散半径距离 + 初始固定扩散值，随进度还原至 0)
  double get spreadRadiusRevert =>
      (spreadRadiusDistance + ((width < height ? width : height) / 10)) *
      (1 - (centerProgress > 1 ? 1 : centerProgress));

  /// 阴影扩散半径
  ///
  /// 阴影扩散半径距离 - 阴影扩散半径距离还原
  double get spreadRadius => spreadRadiusDistance - spreadRadiusRevert;

  /// 是否反向（受光源影响）
  ///
  /// {@macro tilt.ShadowConfig.isReverse}
  bool get isReverse =>
      shadowConfig.isReverse ??
      (shadowConfig.direction == null && (lightConfig.isReverse == true));

  /// 禁用阴影
  bool get shadowDisable =>
      shadowConfig.disable ||
      shadowConfig.intensity == 0 ||
      shadowConfig.direction == ShadowDirection.none;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          if (!shadowDisable)
            BoxShadow(
              color: shadowConfig.color.withOpacity(showShadow),
              offset: isReverse ? -offset : offset,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
              blurStyle: BlurStyle.normal,
            ),
        ],
        borderRadius: borderRadius,
      ),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
