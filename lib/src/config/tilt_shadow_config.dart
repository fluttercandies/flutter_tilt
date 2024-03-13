import 'package:flutter/widgets.dart';

import '../enums.dart';
import '../config/tilt_light_config.dart';

/// Shadow effect config.
/// 阴影效果配置。
@immutable
class ShadowConfig {
  /// Shadow effect config.
  /// 阴影效果配置。
  ///
  /// {@template tilt.ShadowConfig}
  /// 如果阴影配置以下参数将不会受到光源的影响
  ///
  /// - 配置：阴影方向 [ShadowConfig.direction]
  ///   - 失效：光源方向 [LightConfig.direction]
  ///   - 失效：光源反向 [LightConfig.enableReverse]
  /// - 配置：阴影反向 [ShadowConfig.enableReverse]
  ///   - 失效：光源反向 [LightConfig.enableReverse]
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

  /// Only disable the shadow effect.
  ///
  /// ------
  ///
  /// 仅禁用阴影效果。
  final bool disable;

  /// Shadow color.
  ///
  /// ------
  ///
  /// 阴影颜色。
  final Color color;

  /// Color minimum opacity, also initial opacity.
  ///
  /// ------
  ///
  /// 颜色最小不透明度，也是初始不透明度。
  final double minIntensity;

  /// Color maximum opacity as tilt progresses.
  ///
  /// ------
  ///
  /// 颜色最大不透明度，跟随倾斜最大进度。
  final double maxIntensity;

  /// Initial value of shadow offset.
  ///
  /// e.g.
  /// - (0.0, 0.0) center.
  /// - (40.0, 40.0) Offset 40 to the top left.
  ///
  /// ------
  ///
  /// 阴影偏移初始值。
  ///
  /// {@template tilt.ShadowConfig.offsetInitial}
  /// 例如：
  /// - (0, 0) 中心
  /// - (40, 40) 向左上角偏移 40
  /// - (-60, 0) 仅向右偏移 60
  /// {@endtemplate}
  final Offset offsetInitial;

  /// Shadow offset factor,
  /// relative to current widget size.
  ///
  /// ------
  ///
  /// 阴影偏移系数，
  /// 相对于当前 widget 尺寸。
  final double offsetFactor;

  /// Initial value of shadow spread radius.
  ///
  /// ------
  ///
  /// 阴影扩散半径初始值。
  final double spreadInitial;

  /// Shadow spread radius factor,
  /// relative to current widget size.
  ///
  /// ------
  ///
  /// 阴影扩散半径系数，
  /// 相对于当前 widget 尺寸。
  ///
  /// 移动时相对当前的尺寸进行扩散
  final double spreadFactor;

  /// Minimum blur radius, also initial blur radius.
  ///
  /// ------
  ///
  /// 最小阴影模糊半径，也是初始模糊半径。
  final double minBlurRadius;

  /// Maximum blur radius for tilt progresses.
  ///
  /// ------
  ///
  /// 最大阴影模糊半径，跟随倾斜最大进度。
  final double maxBlurRadius;

  /// Shadow direction.
  /// 阴影方向。
  ///
  /// {@template tilt.ShadowConfig.direction}
  /// 指定后将不受以下影响
  /// - 失效：光源方向 [LightConfig.direction]
  /// - 失效：光源反向 [LightConfig.enableReverse]
  /// {@endtemplate}
  final ShadowDirection? direction;

  /// Reverse shadow direction.
  /// 开启反转阴影方向。
  ///
  /// {@template tilt.ShadowConfig.enableReverse}
  /// 指定后将不受以下影响
  /// - 失效：光源反向 [LightConfig.enableReverse]
  /// {@endtemplate}
  final bool? enableReverse;

  ShadowConfig copyWith({
    bool? disable,
    Color? color,
    double? minIntensity,
    double? maxIntensity,
    Offset? offsetInitial,
    double? offsetFactor,
    double? spreadInitial,
    double? spreadFactor,
    double? minBlurRadius,
    double? maxBlurRadius,
    ShadowDirection? direction,
    bool? enableReverse,
  }) {
    return ShadowConfig(
      disable: disable ?? this.disable,
      color: color ?? this.color,
      minIntensity: minIntensity ?? this.minIntensity,
      maxIntensity: maxIntensity ?? this.maxIntensity,
      offsetInitial: offsetInitial ?? this.offsetInitial,
      offsetFactor: offsetFactor ?? this.offsetFactor,
      spreadInitial: spreadInitial ?? this.spreadInitial,
      spreadFactor: spreadFactor ?? this.spreadFactor,
      minBlurRadius: minBlurRadius ?? this.minBlurRadius,
      maxBlurRadius: maxBlurRadius ?? this.maxBlurRadius,
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
    return other is ShadowConfig &&
        other.disable == disable &&
        other.color == color &&
        other.minIntensity == minIntensity &&
        other.maxIntensity == maxIntensity &&
        other.offsetInitial == offsetInitial &&
        other.offsetFactor == offsetFactor &&
        other.spreadInitial == spreadInitial &&
        other.spreadFactor == spreadFactor &&
        other.minBlurRadius == minBlurRadius &&
        other.maxBlurRadius == maxBlurRadius &&
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
      offsetInitial,
      offsetFactor,
      spreadInitial,
      spreadFactor,
      minBlurRadius,
      maxBlurRadius,
      direction,
      enableReverse,
    );
  }
}
