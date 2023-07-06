import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

class Tilt extends StatefulWidget {
  const Tilt({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.z = 0,
  });

  final Widget child;
  final double width;
  final double height;
  final double z;

  @override
  State<Tilt> createState() => _TiltState();
}

class _TiltState extends State<Tilt> {
  Offset position = Offset.zero;

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print("重载");
    return Listener(
      onPointerMove: (event) {
        bindingRange(event.localPosition);
      },
      onPointerHover: (event) {
        bindingRange(event.localPosition);
      },
      onPointerUp: (event) {
        setState(() {
          position = Offset.zero;
        });
      },
      child: Transform(
        key: globalKey,
        alignment: Alignment.center,
        transform: tiltTransform(),
        child: widget.child,
      ),
    );
  }

  /// 计算倾斜
  Matrix4 tiltTransform() {
    final matrix = Matrix4.identity();

    /// 初始状态
    if (position == Offset.zero) {
      matrix.rotateY(0);
      matrix.rotateX(0);

      return matrix;
    }

    /// 近大远小效果
    matrix.setEntry(3, 2, 0.01);

    /// 移动位置
    final double x = position.dx;
    final double y = position.dy;

    /// 内部尺寸
    final double w = widget.width;
    final double h = widget.height;

    /// 旋转角度 (中心位置) / 灵敏度
    final double rotateX = -(w / 2 - x) / w;
    final double rotateY = (h / 2 - y) / h;

    print('X');
    print(rotateY);
    print(y);
    print('Y');
    print(rotateX);
    print(x);

    matrix.rotateY(rotateX);
    matrix.rotateX(rotateY);

    return matrix;
  }

  /// 约束范围
  void bindingRange(Offset offset) {
    /// 移动位置
    final double x = offset.dx;
    final double y = offset.dy;

    /// 内部尺寸
    final double w = widget.width;
    final double h = widget.height;

    /// 触发范围阈值
    const double r = 10;

    if (x <= h + r && x >= -r && y <= w + r && y >= -r) {
      setState(() {
        position = offset;
      });
    }
  }
}
