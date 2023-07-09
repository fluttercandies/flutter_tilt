import 'package:flutter/material.dart';

class TiltShadow extends StatelessWidget {
  const TiltShadow({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.position,
    this.borderRadius,
  });

  final Widget child;
  final double width;
  final double height;

  /// 位置坐标
  final Offset position;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 尺寸 width
  double get w => width;

  /// 尺寸 height
  double get h => height;

  /// 坐标位置 x
  double get x => position.dx;

  /// 坐标位置 y
  double get y => position.dy;

  /// 定位 x （从组件中心位置开始）
  double get xPositioned => x - w / 2;

  /// 定位 y （从组件中心位置开始）
  double get yPositioned => y - h / 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            offset: Offset(xPositioned, yPositioned),
          ),
        ],
      ),
      child: child,
    );
  }
}
