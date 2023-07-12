import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';
import 'package:flutter_tilt/src/type/tilt_shadow_type.dart';

/// 阴影
class TiltShadow extends StatelessWidget {
  /// 阴影
  ///
  /// 作用于其他组件上的阴影效果
  ///
  /// [width], [height] 一般和传入的组件尺寸一致
  ///
  /// {@macro tilt.ShadowConfig}
  const TiltShadow({
    Key? key,
    required this.child,
    required this.width,
    required this.height,
    required this.areaProgress,
    this.borderRadius,
    required this.sensitivity,
    required this.lightConfig,
    required this.shadowConfig,
  }) : super(key: key);

  final Widget child;
  final double width;
  final double height;

  /// 当前坐标的区域进度
  final Offset areaProgress;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 倾斜灵敏度
  final double sensitivity;

  /// 光源配置
  final LightConfig lightConfig;

  /// 阴影配置
  final ShadowConfig shadowConfig;

  /// 当前坐标的区域进度
  Offset get p2cProgress => -areaProgress;

  /// 距离中心的进度
  double get centerProgress => p2pDistance(Offset.zero, p2cProgress);

  /// 阴影当前坐标
  ///
  /// 阴影进度 * 阴影距离 * 100
  Offset get offset => p2cProgress * shadowConfig.distance * 100;

  /// 阴影模糊半径
  ///
  /// 距离中心的进度 * 模糊半径 * 阴影距离
  double get blurRadius =>
      centerProgress * shadowConfig.blurRadius * shadowConfig.distance;

  /// 阴影扩散半径
  ///
  /// (距离中心的进度 * 扩散半径 * 阴影距离 * (倾斜灵敏度 * 10)) - (固定扩散值)
  double get spreadRadius =>
      (centerProgress *
          shadowConfig.spreadRadius *
          shadowConfig.distance *
          (sensitivity * 10)) -
      ((width < height ? width : height) / 10);

  /// 阴影显示（受光源影响）
  ///
  /// 用于阴影颜色，限制最大进度表示强度（透明度）
  ///
  /// {@macro tilt.ShadowConfig.direction}
  double get showShadow => directionProgress(
        width,
        height,
        areaProgress,
        shadowConfig.direction ?? lightConfig.direction,
        max: shadowConfig.intensity,
      );

  /// 是否反向（受光源影响）
  ///
  /// {@macro tilt.ShadowConfig.isReverse}
  bool get isReverse =>
      shadowConfig.isReverse ??
      ((lightConfig.isReverse && shadowConfig.direction == null) &&
          (lightConfig.isReverse && shadowConfig.isReverse == null));

  /// 禁用
  bool get shadowDisable =>
      shadowConfig.disable ||
      shadowConfig.distance == 0 ||
      shadowConfig.intensity == 0 ||
      shadowConfig.direction == ShadowDirection.none;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          if (!shadowDisable)
            BoxShadow(
              color: shadowConfig.color.withOpacity(showShadow),
              offset: isReverse ? -offset : offset,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
              blurStyle: BlurStyle.normal,
            ),
        ],
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
