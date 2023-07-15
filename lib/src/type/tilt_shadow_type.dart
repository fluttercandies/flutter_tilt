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
    this.intensity = 0.5,
    this.offsetFactor = 0.1,
    this.spreadFactor = 0.0,
    this.blurRadius = 20,
    this.direction,
    this.enableReverse,
  })  : assert(intensity >= 0 && intensity <= 1, 'shadowConfig.intensity'),
        assert(offsetFactor >= 0, 'shadowConfig.offsetFactor'),
        assert(spreadFactor >= 0, 'shadowConfig.spreadFactor');

  /// 禁用
  final bool disable;

  /// 阴影颜色
  final Color color;

  /// 阴影强度
  ///
  /// min: 0 max: 1
  ///
  /// 为 0 时将没有阴影
  final double intensity;

  /// 阴影偏移系数
  ///
  /// 相对当前的尺寸进行偏移
  final double offsetFactor;

  /// 阴影扩散系数
  ///
  /// 相对当前的尺寸进行扩散
  final double spreadFactor;

  /// 阴影模糊半径
  final double blurRadius;

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
  /// * [LightConfig.enableReverse] 光源反向
  /// {@endtemplate}
  final bool? enableReverse;
}
