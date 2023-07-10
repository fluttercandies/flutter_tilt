import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/enums.dart';

/// 光源配置
@immutable
class LightConfig {
  /// 光源配置
  const LightConfig({
    this.color = const Color(0xFFFFFFFF),
    this.intensity = 80,
    this.direction = LightDirection.around,
    this.isReverse = false,
  });

  /// 光源颜色
  final Color color;

  /// 光源强度
  ///
  /// min: 0 max: 255
  ///
  /// 为 0 时将没有光源
  final int intensity;

  /// 光源方向
  final LightDirection direction;

  /// 光源是否反向
  final bool isReverse;
}
