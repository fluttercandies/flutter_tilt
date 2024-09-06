/// 方向
sealed class Direction {}

/// Light direction.
/// 光照方向。
///
/// {@macro tilt.LightConfig.direction}
enum LightDirection implements Direction {
  /// 禁用光源
  none,

  /// 周围光源，距离周围越近越亮，距离中心越近越暗。
  around,

  /// 所有坐标位置光源强度一致。
  all,

  /// 仅顶部光源
  top,

  /// 仅底部光源
  bottom,

  /// 仅左侧光源
  left,

  /// 仅右侧光源
  right,

  /// 中心光源，距离中心越近越亮，距离中心越远越暗。
  center,

  /// 仅左上光源
  topLeft,

  /// 仅右上光源
  topRight,

  /// 仅左下光源
  bottomLeft,

  /// 仅右下光源
  bottomRight,

  /// 仅 x 轴中心光源
  xCenter,

  /// 仅 y 轴中心光源
  yCenter,
}

/// Shadow direction.
/// 阴影方向。
///
/// {@macro tilt.ShadowConfig.direction}
enum ShadowDirection implements Direction {
  /// 禁用阴影
  none,

  /// 周围阴影。
  around,

  /// 所有坐标位置阴影强度一致。
  all,

  /// 仅顶部阴影
  top,

  /// 仅底部阴影
  bottom,

  /// 仅左侧阴影
  left,

  /// 仅右侧阴影
  right,

  /// 中心阴影，距离中心越近越深，距离中心越远越淡。
  center,

  /// 仅左上阴影
  topLeft,

  /// 仅右上阴影
  topRight,

  /// 仅左下阴影
  bottomLeft,

  /// 仅右下阴影
  bottomRight,

  /// 仅 x 轴中心阴影
  xCenter,

  /// 仅 y 轴中心阴影
  yCenter,
}

/// GesturesType
/// 手势类型
///
/// Gesture Priority
/// 手势优先级：
///
/// {@template tilt.GesturesType.gesturePriority}
/// [GesturesType.touch] > [GesturesType.hover] > [GesturesType.controller] > [GesturesType.sensors]
/// {@endtemplate}
enum GesturesType { none, touch, hover, controller, sensors }

/// Light & Shadow Mode
/// 光影 Mode
enum LightShadowMode {
  /// [No performance risk]
  ///
  /// Use normal shadow effects only for `Tilt.child` without performance degradation.
  ///
  /// ------
  ///
  /// [无性能风险]
  ///
  /// 仅对 `Tilt.child` 使用普通阴影效果，无性能损耗。
  base,

  /// [Performance risk exists]
  ///
  /// Apply a shadow to the entire `Tilt` widget, similar to a projector effect.
  /// will display a shadow that exactly matches the non-transparent parts of the widget.
  ///
  /// Recommended for the following scenarios:
  /// - Images only
  /// - No data states
  /// - No Hero tags
  ///
  /// ------
  ///
  /// [有性能风险]
  ///
  /// 对整个 `Tilt` widget 使用类似投影仪效果的阴影，
  /// 会显示与 widget 非透明部分完全一致的阴影。
  ///
  /// 建议在以下场景使用：
  /// - 仅图片
  /// - 无数据状态
  /// - 无 Hero 标签
  projector,
}
