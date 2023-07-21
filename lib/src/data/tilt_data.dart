import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';

import 'package:flutter_tilt/src/type/tilt_type.dart';

import 'package:flutter_tilt/src/model/tilt_model.dart';

/// 倾斜数据
@immutable
class TiltData {
  const TiltData({
    required this.isInit,
    required this.width,
    required this.height,
    required this.areaProgress,
    required this.tiltConfig,
  });

  /// 是否初始化
  final bool isInit;

  final double width;

  final double height;

  /// 区域进度
  final Offset areaProgress;

  final TiltConfig tiltConfig;

  TiltDataModel get data => TiltDataModel(
        transform: transform,
        areaProgress: areaProgress,
        angle: angle,
      );

  /// 变换
  Matrix4 get transform => isInit && !disable
      ? tiltTransform(
          width,
          height,
          areaProgress,
          tiltConfig.angle,
          tiltConfig.enableReverse,
        )
      : Matrix4.identity();

  /// 角度
  Offset get angle =>
      rotateAxis(areaProgress * tiltConfig.angle, tiltConfig.enableReverse);

  /// 反向
  bool get enableReverse => tiltConfig.enableReverse;

  /// 禁用
  bool get disable => tiltConfig.disable;
}
