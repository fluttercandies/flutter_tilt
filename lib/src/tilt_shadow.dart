import 'package:flutter/widgets.dart';

import 'utils.dart';
import 'enums.dart';
import 'config/tilt_light_config.dart';
import 'config/tilt_shadow_config.dart';

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
    this.border,
    this.borderRadius,
    required this.clipBehavior,
    required this.lightConfig,
    required this.shadowConfig,
  });

  final Widget child;
  final double width, height;

  /// 当前坐标的区域进度
  final Offset areaProgress;

  /// Border
  final BoxBorder? border;

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

  /// 距离中心的进度最大值
  double get centerMaxProgress => centerProgress > 1.0 ? 1.0 : centerProgress;

  /// 阴影显示（受光源影响）
  ///
  /// 用于阴影颜色，限制最大进度表示强度（透明度）
  ///
  /// {@macro tilt.ShadowConfig.direction}
  double get showShadow => directionProgress(
        areaProgress,
        shadowConfig.direction ?? lightConfig.direction,
        min: shadowConfig.minIntensity,
        max: shadowConfig.maxIntensity,
      );

  /// 阴影当前偏移距离
  ///
  /// 阴影进度 * 阴影偏移系数的距离（相对当前尺寸的中心）
  Offset get baseOffset =>
      progress *
      p2pDistance(
        centerPosition(width, height),
        centerPosition(width, height) * (shadowConfig.offsetFactor + 1.0),
      );

  /// 阴影偏移
  Offset get offset =>
      (enableReverse ? -baseOffset : baseOffset) - shadowConfig.offsetInitial;

  /// 阴影模糊半径进度
  ///
  /// 距离中心的进度 * 最大模糊半径
  double get blurRadiusProgress =>
      centerMaxProgress * shadowConfig.maxBlurRadius;

  /// 阴影模糊半径
  double get blurRadius => blurRadiusProgress < shadowConfig.minBlurRadius
      ? shadowConfig.minBlurRadius
      : blurRadiusProgress;

  /// 阴影扩散半径距离
  ///
  /// (距离中心的进度 * 阴影扩散系数)
  double get spreadRadiusDistance => p2pDistance(
        Offset(width, height),
        Offset(width, height) * (shadowConfig.spreadFactor + 1.0),
      );

  /// 阴影扩散半径距离还原
  ///
  /// 避免初始状态的扩散
  ///
  /// (阴影扩散半径距离 + 初始固定扩散值，随进度还原至 0)
  double get spreadRadiusRevert =>
      (spreadRadiusDistance + ((width < height ? width : height) / 10.0)) *
      (1 - centerMaxProgress);

  /// 阴影扩散半径
  ///
  /// 阴影扩散半径距离 - 阴影扩散半径距离还原 + 起始扩散半径
  double get spreadRadius =>
      spreadRadiusDistance - spreadRadiusRevert + shadowConfig.spreadInitial;

  /// 开启反向（受光源影响）
  ///
  /// {@macro tilt.ShadowConfig.enableReverse}
  bool get enableReverse =>
      shadowConfig.enableReverse ??
      (shadowConfig.direction == null && (lightConfig.enableReverse == true));

  /// 禁用阴影
  bool get shadowDisable =>
      shadowConfig.disable ||
      shadowConfig.maxIntensity == 0.0 ||
      shadowConfig.direction == ShadowDirection.none;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          if (!shadowDisable)
            BoxShadow(
              color: shadowConfig.color.withOpacity(showShadow),
              offset: offset,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
            ),
        ],
        border: border,
        borderRadius: borderRadius,
      ),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
