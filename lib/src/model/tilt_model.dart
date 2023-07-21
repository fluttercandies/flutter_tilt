import 'package:flutter/widgets.dart';

/// 倾斜数据
@immutable
class TiltDataModel {
  const TiltDataModel({
    required this.areaProgress,
    required this.transform,
    required this.angle,
  });

  /// 区域进度
  final Offset areaProgress;

  /// 变换
  final Matrix4 transform;

  /// 角度
  final Offset angle;
}
