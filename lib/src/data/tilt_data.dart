import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/model/tilt_model.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';
import 'package:flutter_tilt/src/utils.dart';

/// 倾斜数据
@immutable
class TiltData {
  /// 倾斜数据
  const TiltData({
    required this.isInit,
    required this.width,
    required this.height,
    required this.areaProgress,
    required this.tiltConfig,
  });

  /// 是否初始化
  final bool isInit;

  /// 尺寸 width
  final double width;

  /// 尺寸 height
  final double height;

  /// 区域进度
  final Offset areaProgress;

  /// 倾斜配置
  final TiltConfig tiltConfig;

  /// 倾斜数据
  TiltDataModel get data => TiltDataModel(
        position: position,
        transform: transform,
        areaProgress: areaProgress,
        angle: angle,
      );

  /// 当前坐标
  Offset get position => progressPosition(width, height, areaProgress);

  /// Transform
  Matrix4 get transform => isInit && !disable
      ? tiltTransform(
          width,
          height,
          areaProgress,
          tiltConfig.angle,
          tiltConfig.enableReverse,
        )
      : Matrix4.identity();

  /// 角度（区分区域）
  ///
  /// {@macro tilt.TiltDataModel.angle}
  Offset get angle =>
      rotateAxis(areaProgress * tiltConfig.angle, tiltConfig.enableReverse);

  /// 禁用
  bool get disable => tiltConfig.disable;
}
