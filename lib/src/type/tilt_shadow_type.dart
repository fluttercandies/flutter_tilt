import 'package:flutter/widgets.dart';

/// 阴影配置
@immutable
class ShadowConfig {
  /// 阴影配置
  const ShadowConfig({
    this.color = const Color(0xFF9E9E9E),
    this.distance = 0.4,
    this.spreadRadius = 0.5,
    this.blurRadius = 100.0,
  });

  /// 阴影颜色
  final Color color;

  /// 阴影距离
  ///
  /// 为 0 时将没有阴影
  final double distance;

  /// 阴影扩散半径
  final double spreadRadius;

  /// 阴影模糊半径
  final double blurRadius;
}
