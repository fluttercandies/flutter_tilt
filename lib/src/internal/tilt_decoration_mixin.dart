import 'package:flutter/widgets.dart';

import '../enums.dart';
import '../utils.dart';

mixin TiltDecoration {
  /// 计算提供的方向进度
  ///
  /// 范围：0-1
  ///
  /// - [areaProgress] 当前坐标的区域进度
  /// - [direction] 方向计算方式
  ///   - [LightDirection] 光线方向
  ///   - [ShadowDirection] 阴影方向
  ///
  /// 可选项
  /// - [min] 最小进度限制 0-1
  /// - [max] 最大进度限制 0-1
  /// - [enableReverse] 开启反向
  ///
  /// @return [double] 方向进度 0-1
  double tiltDecorationDirectionProgress<T>(
    Offset areaProgress,
    T direction, {
    double min = 0.0,
    double max = 1.0,
    bool enableReverse = false,
  }) {
    assert(min <= max && min >= 0.0 && max <= 1.0);

    /// 区域进度
    final Offset progress = -areaProgress;
    final double progressX = progress.dx, progressY = progress.dy;

    /// 距离中心
    final double dataDistance = Utils.p2pDistance(
      Offset.zero,
      Offset(progressX, progressY),
    );

    /// 限制距离中心
    final double constraintsDistance = dataDistance > max ? max : dataDistance;

    /// 区域进度
    double dataX = progressX, dataY = progressY;

    /// 进度
    double progressData = min;

    /// 光源方向计算方式
    if (direction.runtimeType == LightDirection) {
      progressData = switch (direction as LightDirection) {
        LightDirection.none => progressData,
        LightDirection.around => constraintsDistance,
        LightDirection.all => max,
        LightDirection.top => progressY,
        LightDirection.bottom => -progressY,
        LightDirection.left => progressX,
        LightDirection.right => -progressX,
        LightDirection.center => max - constraintsDistance,
        LightDirection.topLeft => progressX + progressY,
        LightDirection.bottomRight => -(progressX + progressY),
        LightDirection.topRight => -(progressX - progressY),
        LightDirection.bottomLeft => progressX - progressY,
        LightDirection.xCenter => max - (progressY < 0.0 ? -progressY : dataY),
        LightDirection.yCenter => max - (progressX < 0.0 ? -progressX : dataX),
      };
    }

    /// 阴影方向计算方式
    if (direction.runtimeType == ShadowDirection) {
      progressData = switch (direction as ShadowDirection) {
        ShadowDirection.none => progressData,
        ShadowDirection.around => constraintsDistance,
        ShadowDirection.all => max,
        ShadowDirection.top => -progressY,
        ShadowDirection.bottom => progressY,
        ShadowDirection.left => -progressX,
        ShadowDirection.right => progressX,
        ShadowDirection.center => max - constraintsDistance,
        ShadowDirection.topLeft => -(progressX + progressY),
        ShadowDirection.bottomRight => progressX + progressY,
        ShadowDirection.topRight => progressX - progressY,
        ShadowDirection.bottomLeft => -(progressX - progressY),
        ShadowDirection.xCenter => max - (progressY < 0.0 ? -progressY : dataY),
        ShadowDirection.yCenter => max - (progressX < 0.0 ? -progressX : dataX),
      };
    }

    /// 强度
    progressData = progressData * max;

    /// 反向
    if (enableReverse) progressData = -progressData;

    /// 避免超出范围
    if (progressData < min) progressData = min;
    if (progressData > max) progressData = max;

    return progressData;
  }
}
