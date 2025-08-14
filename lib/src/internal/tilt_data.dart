import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import '../config/tilt_config.dart';
import '../models/tilt_data_model.dart';
import '../utils.dart';

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
  Offset get position => Utils.progressPosition(width, height, areaProgress);

  /// Transform
  Matrix4 get transform =>
      isInit && !disable ? tiltTransform() : Matrix4.identity();

  /// 实际旋转角度
  ///
  /// {@macro tilt.TiltDataModel.angle}
  Offset get angle => Utils.rotateAxis(
        areaProgress * tiltConfig.angle,
        tiltConfig.enableReverse,
      );

  /// 禁用
  bool get disable => tiltConfig.disable;

  /// 计算当前坐标进度的倾斜
  Matrix4 tiltTransform() {
    final Offset rotate = Utils.rotateAxis(
      /// 旋转大小：区域进度 * 弧度
      areaProgress * Utils.radian(tiltConfig.angle),
      tiltConfig.enableReverse,
    );
    final double rotateX = rotate.dx, rotateY = rotate.dy;
    final double maxSize = math.max(width, height);

    return Matrix4.identity()
      // 近大远小效果（适配不同尺寸的组件）
      ..setEntry(3, 2, 0.5 / maxSize)
      // 旋转轴
      ..rotateX(rotateX)
      ..rotateY(rotateY);
  }
}
