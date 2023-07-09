import 'dart:math';

import 'package:flutter/widgets.dart';

/// 计算倾斜开始
Matrix4 tiltTransform(double w, double h, double x, double y) {
  /// 旋转角度 (中心位置) / 灵敏度
  final double rotateX = -((w / 2 - x) / w);
  final double rotateY = ((h / 2 - y) / h);

  print('Y');
  print(rotateY);
  print(y);
  print('X');
  print(rotateX);
  print(x);

  return Matrix4.identity()

    /// 近大远小效果（适配不同尺寸的组件）
    ..setEntry(3, 2, 0.5 / (w > h ? w : h))

    /// 旋转
    ..rotateY(rotateX)
    ..rotateX(rotateY);
}

/// 计算是否在区域内
bool isInRange(double width, double height, Offset offset) {
  final x = offset.dx, y = offset.dy;
  final w = width, h = height;

  /// 触发范围阈值
  // const double r = 10;

  /// 限制移动范围
  if (x <= w && x >= 0 && y <= h && y >= 0) {
    return true;
  } else {
    return false;
  }
}

/// 两点间的距离 sqrt((x1-x2)²+(y1-y2)²)
///
/// 坐标 (x1, y1) 到坐标 (x2, y2) 的距离
///
double p2pDistance(Offset p1, Offset p2) {
  final x1 = p1.dx, y1 = p1.dy;
  final x2 = p2.dx, y2 = p2.dy;
  return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
}
