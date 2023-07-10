/// 光源方向
enum LightDirection {
  /// 禁用光源
  none,

  /// 周围光源，距离周围越近越亮，距离中心越近越暗。
  around,

  /// 整体光源相同，所有坐标位置光源亮度一致。
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
