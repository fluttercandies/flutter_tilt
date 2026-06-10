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
    this.maxIntensity = 0.25,
    this.spreadFactor = 4.0,
    this.direction = LightDirection.around,
    this.enableReverse,
  })  : assert(
          minIntensity <= maxIntensity &&
              minIntensity >= 0.0 &&
              maxIntensity <= 1.0,
        ),
        assert(spreadFactor >= 1.0);

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

  /// Sentinel value used to distinguish "not provided" from explicit `null`
  /// in [copyWith] for nullable fields like [enableReverse].
  static const Object _absent = Object();

  LightConfig copyWith({
    bool? disable,
    Color? color,
    double? minIntensity,
    double? maxIntensity,
    double? spreadFactor,
    LightDirection? direction,
    Object? enableReverse = _absent,
  }) {
    return LightConfig(
      disable: disable ?? this.disable,
      color: color ?? this.color,
      minIntensity: minIntensity ?? this.minIntensity,
      maxIntensity: maxIntensity ?? this.maxIntensity,
      spreadFactor: spreadFactor ?? this.spreadFactor,
      direction: direction ?? this.direction,
      enableReverse: identical(enableReverse, _absent)
          ? this.enableReverse
          : enableReverse as bool?,
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
      direction,
      enableReverse,
    );
  }
}

/// Light effect config.
/// 光照效果配置。
@Deprecated(
  '\nThe current simulated light effect is not suitable for Projector, '
  'This feature was deprecated after v4.0.0.\n'
  '------\n'
  '当前的模拟光照效果对 Projector 并不合适。此功能在 v4.0.0 版本后已弃用。\n',
)
@immutable
class LightProjectorConfig extends LightConfig {
  /// Light effect config.
  /// 光照效果配置。
  const LightProjectorConfig({
    super.disable = true,
    super.color,
    super.minIntensity,
    super.maxIntensity,
    super.spreadFactor,
    this.projectorScale = 1.1,
    super.direction,
    super.enableReverse,
  }) : assert(projectorScale >= 0.0);

  /// Light area size scale
  ///
  /// ------
  ///
  /// 光照区域尺寸比例
  ///
  final double projectorScale;

  @override
  LightProjectorConfig copyWith({
    bool? disable,
    Color? color,
    double? minIntensity,
    double? maxIntensity,
    double? spreadFactor,
    double? projectorScale,
    LightDirection? direction,
    Object? enableReverse = LightConfig._absent,
  }) {
    return LightProjectorConfig(
      disable: disable ?? this.disable,
      color: color ?? this.color,
      minIntensity: minIntensity ?? this.minIntensity,
      maxIntensity: maxIntensity ?? this.maxIntensity,
      spreadFactor: spreadFactor ?? this.spreadFactor,
      projectorScale: projectorScale ?? this.projectorScale,
      direction: direction ?? this.direction,
      enableReverse: identical(enableReverse, LightConfig._absent)
          ? this.enableReverse
          : enableReverse as bool?,
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
    return other is LightProjectorConfig &&
        super == other &&
        other.projectorScale == projectorScale;
  }

  @override
  int get hashCode {
    return Object.hash(
      super.hashCode,
      projectorScale,
    );
  }
}
