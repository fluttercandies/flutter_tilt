import 'package:flutter/widgets.dart';

import '../../enums.dart';
import '../../utils.dart';

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
  double tiltDecorationDirectionProgress(
    Offset areaProgress,
    Direction direction, {
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

    /// 进度
    double progressData = min;

    progressData = switch (direction) {
      /// 光源方向计算方式
      LightDirection _ => switch (direction) {
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
          LightDirection.xCenter =>
            max - (progressY < 0.0 ? -progressY : progressY),
          LightDirection.yCenter =>
            max - (progressX < 0.0 ? -progressX : progressX),
        },

      /// 阴影方向计算方式
      ShadowDirection _ => switch (direction) {
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
          ShadowDirection.xCenter =>
            max - (progressY < 0.0 ? -progressY : progressY),
          ShadowDirection.yCenter =>
            max - (progressX < 0.0 ? -progressX : progressX),
        },
    };

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
