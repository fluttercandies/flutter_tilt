import 'package:flutter/widgets.dart';

/// 倾斜数据
@immutable
class TiltDataModel {
  /// 倾斜数据
  const TiltDataModel({
    required this.position,
    required this.areaProgress,
    required this.transform,
    required this.angle,
  });

  /// 当前坐标
  final Offset position;

  /// 区域进度
  ///
  /// {@template tilt.TiltDataModel.areaProgress}
  /// 正常范围 (x, y)：(1, 1) 至 (-1, -1)
  ///
  /// 移动过程中的最大倾斜量按照 [TiltConfig.angle] 进行倾斜
  ///
  /// 例如：
  /// * (0, 0) 会保持平面
  /// * (1.0, 1.0) 倾斜左上角 [TiltConfig.angle] 最大角度
  /// * (-1.0, -1.0) 倾斜右下角 [TiltConfig.angle] 最大角度
  /// {@endtemplate}
  final Offset areaProgress;

  /// Transform
  final Matrix4 transform;

  /// 角度（区分区域）
  ///
  /// {@template tilt.TiltDataModel.angle}
  /// 正常范围 (x, y)：(angle, angle) 至 (-angle, -angle)
  ///
  /// 移动过程中的最大倾斜量按照 [TiltConfig.angle] 进行倾斜
  ///
  /// 例如：
  /// * (0, 0) 会保持平面
  /// * (angle, angle) 倾斜左上角 [TiltConfig.angle] 最大角度
  /// * (-angle, -angle) 倾斜右下角 [TiltConfig.angle] 最大角度
  /// {@endtemplate}
  final Offset angle;
}
