import 'package:flutter/widgets.dart';

import '../enums.dart';
import '../utils.dart';

mixin TiltDecoration {
  /// 计算提供的方向进度
  ///
  /// 范围：0-1
  ///
  /// * [width], [height] 区域尺寸
  /// * [areaProgress] 当前坐标的区域进度
  /// * [direction] 方向计算方式
  ///   * [LightDirection] 光线方向
  ///   * [ShadowDirection] 阴影方向
  ///
  /// 可选项
  /// * [min] 最小进度限制 0-1
  /// * [max] 最大进度限制 0-1
  /// * [enableReverse] 开启反向
  ///
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

    /// 区域进度
    late double dataX = progressX, dataY = progressY;

    /// 距离中心
    final double dataDistance = Utils.p2pDistance(
      Offset.zero,
      Offset(dataX, dataY),
    );

    /// 限制距离中心
    final double constraintsDistance = dataDistance > max ? max : dataDistance;

    /// 进度
    late double progressData = min;

    /// 光源方向计算方式
    if (direction.runtimeType == LightDirection) {
      switch (direction as LightDirection) {
        case LightDirection.none:
          break;
        case LightDirection.around:
          final double distance = constraintsDistance;
          progressData = distance;
          break;
        case LightDirection.all:
          progressData = max;
          break;
        case LightDirection.top:
          progressData = progressY;
          break;
        case LightDirection.bottom:
          progressData = -progressY;
          break;
        case LightDirection.left:
          progressData = progressX;
          break;
        case LightDirection.right:
          progressData = -progressX;
          break;
        case LightDirection.center:
          final double distance = constraintsDistance;
          progressData = max - distance;
          break;
        case LightDirection.topLeft:
          progressData = progressX + progressY;
          break;
        case LightDirection.bottomRight:
          progressData = -(progressX + progressY);
          break;
        case LightDirection.topRight:
          progressData = -(progressX - progressY);
          break;
        case LightDirection.bottomLeft:
          progressData = progressX - progressY;
          break;
        case LightDirection.xCenter:
          if (progressY < 0.0) dataY = -progressY;
          progressData = max - dataY;
          break;
        case LightDirection.yCenter:
          if (progressX < 0.0) dataX = -progressX;
          progressData = max - dataX;
          break;
      }
    }

    /// 阴影方向计算方式
    if (direction.runtimeType == ShadowDirection) {
      switch (direction as ShadowDirection) {
        case ShadowDirection.none:
          break;
        case ShadowDirection.around:
          final double distance = constraintsDistance;
          progressData = distance;
          break;
        case ShadowDirection.all:
          progressData = max;
          break;
        case ShadowDirection.top:
          progressData = -progressY;
          break;
        case ShadowDirection.bottom:
          progressData = progressY;
          break;
        case ShadowDirection.left:
          progressData = -progressX;
          break;
        case ShadowDirection.right:
          progressData = progressX;
          break;
        case ShadowDirection.center:
          final double distance = constraintsDistance;
          progressData = max - distance;
          break;
        case ShadowDirection.topLeft:
          progressData = -(progressX + progressY);
          break;
        case ShadowDirection.bottomRight:
          progressData = progressX + progressY;
          break;
        case ShadowDirection.topRight:
          progressData = progressX - progressY;
          break;
        case ShadowDirection.bottomLeft:
          progressData = -(progressX - progressY);
          break;
        case ShadowDirection.xCenter:
          if (progressY < 0.0) dataY = -progressY;
          progressData = max - dataY;
          break;
        case ShadowDirection.yCenter:
          if (progressX < 0.0) dataX = -progressX;
          progressData = max - dataX;
          break;
      }
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
