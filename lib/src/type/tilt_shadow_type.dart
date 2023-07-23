import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';

/// 阴影配置
@immutable
class ShadowConfig {
  /// 阴影配置
  ///
  /// {@template tilt.ShadowConfig}
  /// 如果阴影配置以下参数将不会受到光源的影响
  ///
  /// * 配置：阴影方向 [ShadowConfig.direction]
  ///   * 失效：光源方向 [LightConfig.direction]
  ///   * 失效：光源反向 [LightConfig.enableReverse]
  /// * 配置：阴影反向 [ShadowConfig.enableReverse]
  ///   * 失效：光源反向 [LightConfig.enableReverse]
  /// {@endtemplate}
  const ShadowConfig({
    this.disable = false,
    this.color = const Color(0xFF9E9E9E),
    this.minIntensity = 0.0,
    this.maxIntensity = 0.5,
    this.offsetInitial = Offset.zero,
    this.offsetFactor = 0.1,
    this.spreadInitial = 0.0,
    this.spreadFactor = 0.0,
    this.minBlurRadius = 10.0,
    this.maxBlurRadius = 20.0,
    this.direction,
    this.enableReverse,
  })  : assert(
          minIntensity <= maxIntensity &&
              minIntensity >= 0.0 &&
              maxIntensity <= 1.0,
        ),
        assert(offsetFactor >= 0.0),
        assert(spreadFactor >= 0.0),
        assert(minBlurRadius <= maxBlurRadius && minBlurRadius >= 0.0);

  /// 禁用
  final bool disable;

  /// 阴影颜色
  final Color color;

  /// 最小阴影强度（不透明度）
  ///
  /// 范围：0 - 1
  final double minIntensity;

  /// 最大阴影强度（不透明度）
  ///
  /// 范围：0 - 1
  ///
  /// 为 0 时将没有光源
  final double maxIntensity;

  /// 阴影起始偏移点
  ///
  /// {@template tilt.ShadowConfig.offsetInitial}
  /// 指定起始值以像素单位进行方向 (x, y) 偏移，
  /// 之后移动偏移将以该值作为起始点。
  ///
  /// 例如：
  /// * (0, 0) 中心
  /// * (40, 40) 向左上角偏移 40 像素
  /// * (-60, 0) 仅向右偏移 60 像素
  /// {@endtemplate}
  final Offset offsetInitial;

  /// 阴影偏移系数
  ///
  /// 移动时相对当前的尺寸进行偏移
  final double offsetFactor;

  /// 阴影起始扩散半径
  ///
  /// {@template tilt.ShadowConfig.spreadInitial}
  /// 指定起始值以像素单位初始扩散半径
  /// {@endtemplate}
  final double spreadInitial;

  /// 阴影扩散系数
  ///
  /// 移动时相对当前的尺寸进行扩散
  final double spreadFactor;

  /// 最小阴影模糊半径
  final double minBlurRadius;

  /// 最大阴影模糊半径
  final double maxBlurRadius;

  /// 阴影方向
  ///
  /// {@template tilt.ShadowConfig.direction}
  /// 指定后将不受以下影响
  /// * 失效：光源方向 [LightConfig.direction]
  /// * 失效：光源反向 [LightConfig.enableReverse]
  /// {@endtemplate}
  final ShadowDirection? direction;

  /// 开启阴影反向
  ///
  /// {@template tilt.ShadowConfig.enableReverse}
  /// 指定后将不受以下影响
  /// * 失效：光源反向 [LightConfig.enableReverse]
  /// {@endtemplate}
  final bool? enableReverse;
}
