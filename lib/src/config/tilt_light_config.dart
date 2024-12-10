import 'package:flutter/widgets.dart';

import '../config/tilt_shadow_config.dart';
import '../enums.dart';

/// Light effect config.
/// 光照效果配置。
@immutable
class LightConfig {
  /// Light effect config.
  /// 光照效果配置。
  ///
  /// {@template tilt.LightConfig}
  /// 光源部分配置会影响阴影效果，
  /// 如果需要改变阴影效果，请指定阴影配置 [ShadowConfig]
  /// {@endtemplate}
  const LightConfig({
    this.disable = false,
    this.color = const Color(0xFFFFFFFF),
    this.minIntensity = 0.0,
    this.maxIntensity = 0.5,
    this.spreadFactor = 4.0,
    this.projectorScale = 1.1,
    this.direction = LightDirection.around,
    this.enableReverse,
  })  : assert(
          minIntensity <= maxIntensity &&
              minIntensity >= 0.0 &&
              maxIntensity <= 1.0,
        ),
        assert(spreadFactor >= 1.0),
        assert(projectorScale >= 0.0);

  /// Only disable the light effect.
  ///
  /// ------
  ///
  /// 仅禁用光照效果。
  final bool disable;

  /// Light color.
  ///
  /// ------
  ///
  /// 光照颜色。
  final Color color;

  /// Color minimum opacity, also initial opacity.
  ///
  /// ------
  ///
  /// 颜色最小不透明度，也是初始不透明度。
  final double minIntensity;

  /// Color maximum opacity for tilt progresses.
  ///
  /// ------
  ///
  /// 颜色最大不透明度，跟随倾斜最大进度。
  final double maxIntensity;

  /// Light spread factor,
  /// relative to current widget size.
  ///
  /// ------
  ///
  /// 光源扩散系数，
  /// 相对于当前 widget 尺寸。
  final double spreadFactor;

  /// Light area size scale
  ///
  /// Only the following mode:
  /// [LightShadowMode.projector]
  ///
  /// ------
  ///
  /// 光照区域尺寸比例
  ///
  /// 仅以下模式生效：
  /// [LightShadowMode.projector]
  ///
  final double projectorScale;

  /// Light direction.
  ///
  /// Affects:
  /// - [ShadowConfig.direction] (not affected after configuration).
  ///
  /// ------
  ///
  /// 光照方向。
  ///
  /// {@template tilt.LightConfig.direction}
  /// 光源方向会影响阴影以下效果，
  /// 如果需要改变阴影效果，请指定阴影配置 [ShadowConfig]
  ///
  /// - 阴影方向 [ShadowConfig.direction]
  /// {@endtemplate}
  final LightDirection direction;

  /// Reverse light direction.
  ///
  /// Affects:
  /// - [ShadowConfig.direction] (not affected after configuration).
  /// - [ShadowConfig.enableReverse] (not affected after configuration).
  ///
  /// ------
  ///
  /// 开启反转光照方向。
  ///
  /// {@template tilt.LightConfig.enableReverse}
  /// 光源反向会影响以下阴影效果，
  /// 如果需要改变阴影效果，请指定阴影配置 [ShadowConfig]
  ///
  /// - 阴影方向 [ShadowConfig.direction]
  /// - 阴影反向 [ShadowConfig.enableReverse]
  /// {@endtemplate}
  final bool? enableReverse;

  LightConfig copyWith({
    bool? disable,
    Color? color,
    double? minIntensity,
    double? maxIntensity,
    double? spreadFactor,
    double? projectorScale,
    LightDirection? direction,
    bool? enableReverse,
  }) {
    return LightConfig(
      disable: disable ?? this.disable,
      color: color ?? this.color,
      minIntensity: minIntensity ?? this.minIntensity,
      maxIntensity: maxIntensity ?? this.maxIntensity,
      spreadFactor: spreadFactor ?? this.spreadFactor,
      projectorScale: projectorScale ?? this.projectorScale,
      direction: direction ?? this.direction,
      enableReverse: enableReverse ?? this.enableReverse,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is LightConfig &&
        other.disable == disable &&
        other.color == color &&
        other.minIntensity == minIntensity &&
        other.maxIntensity == maxIntensity &&
        other.spreadFactor == spreadFactor &&
        other.projectorScale == projectorScale &&
        other.direction == direction &&
        other.enableReverse == enableReverse;
  }

  @override
  int get hashCode {
    return Object.hash(
      disable,
      color,
      minIntensity,
      maxIntensity,
      spreadFactor,
      projectorScale,
      direction,
      enableReverse,
    );
  }
}
