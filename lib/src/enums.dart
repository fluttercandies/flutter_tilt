/// 光源方向
///
/// 同时会影响阴影方向
enum LightDirection {
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

/// 阴影方向
///
/// 指定后将不受以下影响
/// * [LightConfig.direction] 光源方向
/// * [LightConfig.enableReverse] 光源反向
///
enum ShadowDirection {
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
