import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/type/tilt_shadow_type.dart';

/// 光源配置
@immutable
class LightConfig {
  /// 光源配置
  ///
  /// {@template tilt.LightConfig}
  /// 光源部分配置会影响阴影效果，
  /// 如果需要改变阴影效果，请指定阴影配置 [ShadowConfig]
  /// {@endtemplate}
  const LightConfig({
    this.disable = false,
    this.color = const Color(0xFFFFFFFF),
    this.minIntensity = 0.0,
    this.maxIntensity = 0.4,
    this.direction = LightDirection.around,
    this.enableReverse,
  }) : assert(minIntensity <= maxIntensity &&
            minIntensity >= 0 &&
            maxIntensity <= 1);

  /// 禁用
  final bool disable;

  /// 光源颜色
  final Color color;

  /// 最小光源强度
  ///
  /// 范围：0 - 1
  final double minIntensity;

  /// 最大光源强度
  ///
  /// 范围：0 - 1
  ///
  /// 为 0 时将没有光源
  final double maxIntensity;

  /// 光源方向
  ///
  /// {@template tilt.LightConfig.direction}
  /// 光源方向会影响阴影以下效果，
  /// 如果需要改变阴影效果，请指定阴影配置 [ShadowConfig]
  ///
  /// * 阴影方向 [ShadowConfig.direction]
  /// {@endtemplate}
  final LightDirection direction;

  /// 开启光源反向
  ///
  /// {@template tilt.LightConfig.enableReverse}
  /// 光源反向会影响以下阴影效果，
  /// 如果需要改变阴影效果，请指定阴影配置 [ShadowConfig]
  ///
  /// * 阴影方向 [ShadowConfig.direction]
  /// * 阴影反向 [ShadowConfig.enableReverse]
  /// {@endtemplate}
  final bool? enableReverse;
}
