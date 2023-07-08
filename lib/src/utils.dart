import 'package:flutter/widgets.dart';

/// 计算倾斜开始
Matrix4 tiltTransform(double w, double h, double x, double y) {
  final matrix = Matrix4.identity();

  /// 旋转角度 (中心位置) / 灵敏度
  final double rotateX = -((w / 2 - x) / w);
  final double rotateY = ((h / 2 - y) / h);

  print('Y');
  print(rotateY);
  print(y);
  print('X');
  print(rotateX);
  print(x);

  /// 近大远小效果（适配不同尺寸的组件）
  matrix.setEntry(3, 2, 0.5 / (w > h ? w : h));

  /// 旋转
  matrix.rotateY(rotateX);
  matrix.rotateX(rotateY);

  return matrix;
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
