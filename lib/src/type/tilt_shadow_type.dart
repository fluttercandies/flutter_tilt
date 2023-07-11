import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';

/// 阴影配置
@immutable
class ShadowConfig {
  /// 阴影配置
  ///
  /// 如果配置以下参数将不会受到光源的部分影响
  ///
  /// * 配置：阴影方向 [ShadowConfig.direction]
  ///   * 失效：光源方向 [LightConfig.direction]
  ///   * 失效：光源反向 [LightConfig.isReverse]
  /// * 配置：阴影反向 [ShadowConfig.isReverse]
  ///   * 失效：光源反向 [LightConfig.isReverse]
  ///
  const ShadowConfig({
    this.color = const Color(0xFF9E9E9E),
    this.intensity = 0.5,
    this.distance = 0.5,
    this.spreadRadius = 0.5,
    this.blurRadius = 100.0,
    this.direction,
    this.isReverse,
  }) : assert(intensity >= 0 && intensity <= 1,
            'shadowConfig.intensity value is wrong, range is 0-1');

  /// 阴影颜色
  final Color color;

  /// 阴影强度
  ///
  /// min: 0 max: 1
  ///
  /// 为 0 时将没有阴影
  final double intensity;

  /// 阴影距离
  ///
  /// 为 0 时将没有阴影
  final double distance;

  /// 阴影扩散半径
  final double spreadRadius;

  /// 阴影模糊半径
  final double blurRadius;

  /// 阴影方向
  ///
  /// 指定后将不受以下影响
  /// * 失效：光源方向 [LightConfig.direction]
  /// * 失效：光源反向 [LightConfig.isReverse]
  ///
  final ShadowDirection? direction;

  /// 阴影是否反向
  ///
  /// 指定后将不受以下影响
  /// * [LightConfig.isReverse] 光源反向
  ///
  final bool? isReverse;
}
