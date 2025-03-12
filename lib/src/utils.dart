import 'dart:math';

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/widgets.dart';

import 'config/tilt_config.dart';

abstract final class Utils {
  /// 传感器平台支持
  ///
  /// @return [bool] true: 传感器支持 false: 传感器不支持
  static bool sensorsPlatformSupport() {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => true,
      TargetPlatform.iOS => true,
      _ => false
    };
  }

  /// 区域中心定位
  ///
  /// - [width], [height] 区域尺寸
  ///
  /// @return [Offset] 中心定位
  static Offset centerPosition(double width, double height) =>
      Offset(width, height) / 2;

  /// 弧度
  ///
  /// - [angle] 角度
  ///
  /// @return [double] 弧度
  static double radian(double angle) => pi / 180.0 * angle;

  /// 两点间的距离 sqrt((x1-x2)²+(y1-y2)²)
  ///
  /// 坐标 (x1, y1) 到坐标 (x2, y2) 的距离
  ///
  /// - [p1] 坐标1
  /// - [p2] 坐标2
  ///
  /// @return [double] 两点间的距离
  static double p2pDistance(Offset p1, Offset p2) {
    final double x1 = p1.dx, y1 = p1.dy;
    final double x2 = p2.dx, y2 = p2.dy;
    return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
  }

  /// 旋转轴
  ///
  /// - [rotate] 旋转大小
  /// - [enableReverse] 反向
  ///
  /// @return [Offset] 旋转轴大小
  static Offset rotateAxis(Offset rotate, bool enableReverse) => enableReverse
      ? Offset(-rotate.dy, rotate.dx)
      : Offset(rotate.dy, -rotate.dx);

  /// 计算当前坐标相对于中心坐标的区域坐标
  ///
  /// PositionToCenterAreaPosition
  ///
  /// 可以定位当前坐标正处于的区域方向，以及区域内的坐标位置
  ///
  /// (x, y) = (0, 0) 为中心点
  ///
  /// (x, y) 区域坐标范围：(width / 2, height / 2) 到 (-width / 2, -height / 2)
  ///
  /// 如果值超出了区域坐标范围，那么代表这个坐标不在区域内
  ///
  /// - [width], [height] 区域尺寸
  /// - [position] 当前坐标定位
  ///
  /// @return [Offset] 当前坐标相对于中心坐标的区域坐标
  static Offset p2cAreaPosition(double width, double height, Offset position) {
    final Offset center = centerPosition(width, height);
    final double centerWidth = width / 2.0;
    final double centerHeight = height / 2.0;
    double x = center.dx - position.dx;
    double y = center.dy - position.dy;

    /// 限制最大值
    if (x > centerWidth) x = centerWidth;
    if (x < -centerWidth) x = -centerWidth;
    if (y > centerHeight) y = centerHeight;
    if (y < -centerHeight) y = -centerHeight;

    return Offset(x, y);
  }

  /// 计算当前坐标在中心坐标到区域边界的进度
  ///
  /// PositionToCenterAreaProgress
  ///
  /// 可以定位当前坐标正处于的区域方向，以及区域内到边界的进度
  ///
  /// (x, y) = (0, 0) 为中心点
  ///
  /// (x, y) 区域进度范围：(1, 1) 到 (-1,-1)
  ///
  /// 如果值超出了区域进度范围，那么代表这个坐标不在区域内，比如 (1.1, 1), (-1, 1.1)
  ///
  /// - [width], [height] 区域尺寸
  /// - [position] 当前坐标定位
  /// - [tiltDirection] 倾斜方向限制
  ///
  /// @return [Offset] 当前坐标在中心坐标到区域边界的进度
  static Offset p2cAreaProgress(
    double width,
    double height,
    Offset position,
    List<TiltDirection>? tiltDirection,
  ) {
    if (width == 0.0 || height == 0.0) return Offset.zero;
    final Offset center = centerPosition(width, height);
    final List<TiltDirection> tiltDirectionList = <TiltDirection>[
      ...?tiltDirection,
    ];
    double x = (center.dx - position.dx) / width * 2.0;
    double y = (center.dy - position.dy) / height * 2.0;

    /// 限制最大值
    if (x > 1.0) x = 1.0;
    if (x < -1.0) x = -1.0;
    if (y > 1.0) y = 1.0;
    if (y < -1.0) y = -1.0;

    /// 限制倾斜方向
    if (tiltDirectionList.isNotEmpty) {
      final TiltDirection direction = TiltDirection.validator(
        TiltDirection(x, y),
        tiltDirectionList,
      );
      x = direction.dx;
      y = direction.dy;
    }

    return Offset(x, y);
  }

  /// 通过 [p2cAreaProgress] 的进度，获得当前坐标位置
  ///
  /// - [width], [height] 区域尺寸
  /// - [areaProgress] 区域进度
  ///
  /// @return [Offset] 当前坐标
  static Offset progressPosition(
    double width,
    double height,
    Offset areaProgress,
  ) {
    if (width == 0.0 || height == 0.0) return Offset.zero;
    return Offset(
      width / 2.0 * (1.0 - areaProgress.dx),
      height / 2.0 * (1.0 - areaProgress.dy),
    );
  }

  /// 计算坐标是否在区域内
  ///
  /// - [width], [height] 区域尺寸
  /// - [position] 当前坐标定位
  ///
  /// @return [bool] true: 在区域内 false: 不在区域内
  static bool isInRange(double width, double height, Offset position) {
    final double x = position.dx, y = position.dy;
    return x <= width && x >= 0.0 && y <= height && y >= 0.0;
  }

  /// 限制区域尺寸定位
  ///
  /// - [width], [height] 区域尺寸
  /// - [position] 需要限制的定位
  ///
  /// @return [Offset] 限制后的区域定位
  static Offset constraintsPosition(
    double width,
    double height,
    Offset position,
  ) {
    double constraintWidth = position.dx;
    double constraintHeight = position.dy;

    if (constraintWidth > width) constraintWidth = width;
    if (constraintWidth < 0) constraintWidth = 0;
    if (constraintHeight > height) constraintHeight = height;
    if (constraintHeight < 0) constraintHeight = 0;

    return Offset(constraintWidth, constraintHeight);
  }
}
