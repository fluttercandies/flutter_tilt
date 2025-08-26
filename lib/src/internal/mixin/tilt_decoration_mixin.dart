import 'package:flutter/widgets.dart';

import '../../enums.dart';
import '../../utils.dart';

mixin TiltDecorationMixin {
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
  double tiltDecorationDirectionProgress(
    Offset areaProgress,
    Direction direction, {
    double min = 0.0,
    double max = 1.0,
    bool enableReverse = false,
  }) {
    assert(min <= max && min >= 0.0 && max <= 1.0);

    /// 区域进度（取反）
    final progress = -areaProgress;
    final progressX = progress.dx, progressY = progress.dy;

    /// 距离中心
    final distanceFromCenter = Utils.p2pDistance(
      Offset.zero,
      Offset(progressX, progressY),
    );

    /// 限制距离中心
    final constrainedDistance = distanceFromCenter.clamp(min, max);

    /// 根据方向计算进度
    var progressData = _calculateDirectionProgress(
      direction,
      progressX,
      progressY,
      constrainedDistance,
      max,
    );

    /// 强度调整
    progressData *= max;

    /// 反向处理
    if (enableReverse) progressData = -progressData;

    /// 避免超出范围
    progressData = progressData.clamp(min, max);

    return progressData;
  }

  /// 根据方向计算进度
  ///
  /// - [direction] 光照方向
  /// - [progressX] 当前水平进度
  /// - [progressY] 当前垂直进度
  /// - [constrainedDistance] 限制后的距离（距离中心）
  /// - [max] 最大进度限制 0-1
  ///
  /// @return 对应方向的进度
  double _calculateDirectionProgress(
    Direction direction,
    double progressX,
    double progressY,
    double constrainedDistance,
    double max,
  ) {
    return switch (direction) {
      LightDirection _ => _calculateLightDirectionProgress(
          direction,
          progressX,
          progressY,
          constrainedDistance,
          max,
        ),
      ShadowDirection _ => _calculateShadowDirectionProgress(
          direction,
          progressX,
          progressY,
          constrainedDistance,
          max,
        ),
    };
  }

  /// 计算光照方向的进度
  ///
  /// - [direction] 光照方向
  /// - [progressX] 当前水平进度
  /// - [progressY] 当前垂直进度
  /// - [constrainedDistance] 限制后的距离（距离中心）
  /// - [max] 最大进度限制 0-1
  ///
  /// @return 对应方向的进度
  double _calculateLightDirectionProgress(
    LightDirection direction,
    double progressX,
    double progressY,
    double constrainedDistance,
    double max,
  ) {
    return switch (direction) {
      LightDirection.none => 0.0,
      LightDirection.around => constrainedDistance,
      LightDirection.all => max,
      LightDirection.top => progressY,
      LightDirection.bottom => -progressY,
      LightDirection.left => progressX,
      LightDirection.right => -progressX,
      LightDirection.center => max - constrainedDistance,
      LightDirection.topLeft => progressX + progressY,
      LightDirection.bottomRight => -(progressX + progressY),
      LightDirection.topRight => -(progressX - progressY),
      LightDirection.bottomLeft => progressX - progressY,
      LightDirection.xCenter => max - progressY.abs(),
      LightDirection.yCenter => max - progressX.abs(),
    };
  }

  /// 计算阴影方向的进度
  ///
  /// - [direction] 阴影方向
  /// - [progressX] 当前水平进度
  /// - [progressY] 当前垂直进度
  /// - [constrainedDistance] 限制后的距离（距离中心）
  /// - [max] 最大进度限制 0-1
  ///
  /// @return 对应方向的进度
  double _calculateShadowDirectionProgress(
    ShadowDirection direction,
    double progressX,
    double progressY,
    double constrainedDistance,
    double max,
  ) {
    return switch (direction) {
      ShadowDirection.none => 0.0,
      ShadowDirection.around => constrainedDistance,
      ShadowDirection.all => max,
      ShadowDirection.top => -progressY,
      ShadowDirection.bottom => progressY,
      ShadowDirection.left => -progressX,
      ShadowDirection.right => progressX,
      ShadowDirection.center => max - constrainedDistance,
      ShadowDirection.topLeft => -(progressX + progressY),
      ShadowDirection.bottomRight => progressX + progressY,
      ShadowDirection.topRight => progressX - progressY,
      ShadowDirection.bottomLeft => -(progressX - progressY),
      ShadowDirection.xCenter => max - progressY.abs(),
      ShadowDirection.yCenter => max - progressX.abs(),
    };
  }
}
