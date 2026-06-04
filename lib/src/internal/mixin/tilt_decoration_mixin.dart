import 'package:flutter/widgets.dart';

import '../../enums.dart';
import '../../utils/utils.dart';

mixin TiltDecorationMixin {
  /// 计算提供的方向强度
  ///
  /// 范围：0-1
  ///
  /// - [areaProgress] 当前坐标的区域进度
  /// - [direction] 方向计算方式
  ///   - [LightDirection] 光线方向
  ///   - [ShadowDirection] 阴影方向
  ///
  /// 可选项
  /// - [min] 最小强度限制 0-1
  /// - [max] 最大强度限制 0-1
  ///
  /// @return [double] 方向强度，映射到 [min] - [max] 区间
  double tiltDecorationDirectionIntensity(
    Offset areaProgress,
    Direction direction, {
    double min = 0.0,
    double max = 1.0,
  }) {
    assert(min <= max && min >= 0.0 && max <= 1.0);

    /// 区域进度（取反）
    final progress = -areaProgress;
    final progressX = progress.dx, progressY = progress.dy;

    /// 根据方向计算强度
    var intensity = _calculateDirectionIntensity(
      direction,
      progressX,
      progressY,
    );

    /// 将强度限制在 0-1
    intensity = intensity.clamp(0.0, 1.0);

    /// 按 min-max 区间映射：强度 0 对应 min，强度 1 对应 max
    intensity = min + intensity * (max - min);

    return intensity;
  }

  /// 根据方向计算强度
  ///
  /// - [direction] 光照方向
  /// - [progressX] 当前水平进度
  /// - [progressY] 当前垂直进度
  ///
  /// @return 对应方向的强度
  double _calculateDirectionIntensity(
    Direction direction,
    double progressX,
    double progressY,
  ) {
    return switch (direction) {
      LightDirection _ => _calculateLightDirectionIntensity(
          direction,
          progressX,
          progressY,
        ),
      ShadowDirection _ => _calculateShadowDirectionIntensity(
          direction,
          progressX,
          progressY,
        ),
    };
  }

  /// 计算距离中心点的距离，并限制在 0-1 范围内
  ///
  /// - [progressX] 当前水平进度
  /// - [progressY] 当前垂直进度
  ///
  /// @return 限制在 0-1 范围内的距离
  double _constrainedDistance(
    double progressX,
    double progressY,
  ) {
    final distance = Utils.p2pDistance(
      Offset.zero,
      Offset(progressX, progressY),
    );
    return distance.clamp(0, 1);
  }

  /// 计算光照方向的强度
  ///
  /// - [direction] 光照方向
  /// - [progressX] 当前水平进度
  /// - [progressY] 当前垂直进度
  ///
  /// @return 对应方向的强度
  double _calculateLightDirectionIntensity(
    LightDirection direction,
    double progressX,
    double progressY,
  ) {
    return switch (direction) {
      LightDirection.none => 0.0,
      LightDirection.around => _constrainedDistance(progressX, progressY),
      LightDirection.all => 1,
      LightDirection.top => progressY,
      LightDirection.bottom => -progressY,
      LightDirection.left => progressX,
      LightDirection.right => -progressX,
      LightDirection.center => 1 - _constrainedDistance(progressX, progressY),
      LightDirection.topLeft => progressX + progressY,
      LightDirection.bottomRight => -(progressX + progressY),
      LightDirection.topRight => -(progressX - progressY),
      LightDirection.bottomLeft => progressX - progressY,
      LightDirection.xCenter => 1 - progressY.abs(),
      LightDirection.yCenter => 1 - progressX.abs(),
    };
  }

  /// 计算阴影方向的强度
  ///
  /// - [direction] 阴影方向
  /// - [progressX] 当前水平进度
  /// - [progressY] 当前垂直进度
  ///
  /// @return 对应方向的强度
  double _calculateShadowDirectionIntensity(
    ShadowDirection direction,
    double progressX,
    double progressY,
  ) {
    return switch (direction) {
      ShadowDirection.none => 0.0,
      ShadowDirection.around => _constrainedDistance(progressX, progressY),
      ShadowDirection.all => 1,
      ShadowDirection.top => -progressY,
      ShadowDirection.bottom => progressY,
      ShadowDirection.left => -progressX,
      ShadowDirection.right => progressX,
      ShadowDirection.center => 1 - _constrainedDistance(progressX, progressY),
      ShadowDirection.topLeft => -(progressX + progressY),
      ShadowDirection.bottomRight => progressX + progressY,
      ShadowDirection.topRight => progressX - progressY,
      ShadowDirection.bottomLeft => -(progressX - progressY),
      ShadowDirection.xCenter => 1 - progressY.abs(),
      ShadowDirection.yCenter => 1 - progressX.abs(),
    };
  }
}
