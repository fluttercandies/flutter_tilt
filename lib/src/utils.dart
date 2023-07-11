import 'dart:math';

import 'package:flutter/widgets.dart';

/// 区域中心定位
///
/// [width], [height] 区域尺寸
Offset centerPosition(double width, double height) =>
    Offset(width / 2, height / 2);

/// 计算当前定位的倾斜
///
/// [width], [height] 区域尺寸
///
/// [position] 当前坐标定位
///
/// [sensitivity] 灵敏度，为 0 将会停止不动
Matrix4 tiltTransform(
  double width,
  double height,
  Offset position,
  double sensitivity,
) {
  /// 旋转大小进度：区域进度 * 灵敏度
  final rotate = p2cAreaProgress(width, height, position) * sensitivity;

  late double rotateX = rotate.dx, rotateY = rotate.dy;

  return Matrix4.identity()

    /// 近大远小效果（适配不同尺寸的组件）
    ..setEntry(3, 2, 0.5 / (width > height ? width : height))

    /// 旋转轴
    ..rotateY(-rotateX)
    ..rotateX(rotateY);
}

/// 计算当前坐标相对于中心坐标的区域坐标
///
/// PostionToCenterAreaPostion
///
/// 可以定位当前坐标正处于的区域方向，以及区域内的坐标位置
///
/// [width], [height] 区域尺寸
///
/// [position] 当前坐标定位
///
/// (x, y) = (0, 0) 为中心点
///
/// (x, y) 区域坐标范围：(width / 2, height / 2) 到 (-width / 2, -height / 2)
///
/// 如果值超出了区域坐标范围，那么代表这个坐标不在区域内
Offset p2cAreaPostion(double width, double height, Offset position) {
  final Offset center = centerPosition(width, height);
  late double x = center.dx - position.dx;
  late double y = center.dy - position.dy;

  final double centerWidth = width / 2;
  final double centerHeight = height / 2;

  /// 限制最大值
  if (x > centerWidth) x = centerWidth;
  if (x < -centerWidth) x = -centerWidth;
  if (y > centerHeight) y = centerHeight;
  if (y < -centerHeight) y = -centerHeight;

  return Offset(x, y);
}

/// 计算当前坐标在中心坐标到区域边界的进度
///
/// PostionToCenterAreaProgress
///
/// 可以定位当前坐标正处于的区域方向，以及区域内到边界的进度
///
/// [width], [height] 区域尺寸
///
/// [position] 当前坐标定位
///
/// (x, y) = (0, 0) 为中心点
///
/// (x, y) 区域进度范围：(1, 1) 到 (-1,-1)
///
/// 如果值超出了区域进度范围，那么代表这个坐标不在区域内，比如 (1.1, 1), (-1, 1.1)
Offset p2cAreaProgress(double width, double height, Offset position) {
  final Offset center = centerPosition(width, height);
  late double x = (center.dx - position.dx) / width * 2;
  late double y = (center.dy - position.dy) / height * 2;

  /// 限制最大值
  if (x > 1) x = 1;
  if (x < -1) x = -1;
  if (y > 1) y = 1;
  if (y < -1) y = -1;

  return Offset(x, y);
}

/// 计算坐标是否在区域内
///
/// [width], [height] 区域尺寸
///
/// [position] 当前坐标定位
bool isInRange(double width, double height, Offset position) {
  final double x = position.dx, y = position.dy;

  /// 触发范围阈值
  // const double r = 10;

  /// 限制移动范围
  return x <= width && x >= 0 && y <= height && y >= 0;
}

/// 两点间的距离 sqrt((x1-x2)²+(y1-y2)²)
///
/// 坐标 (x1, y1) 到坐标 (x2, y2) 的距离
double p2pDistance(Offset p1, Offset p2) {
  final double x1 = p1.dx, y1 = p1.dy;
  final double x2 = p2.dx, y2 = p2.dy;
  return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
}
