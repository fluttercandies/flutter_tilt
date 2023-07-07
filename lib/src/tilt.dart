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
  /// 移动的位置
  late Offset position;

  /// 初始的尺寸
  late Offset initPosition;

  /// 是否正在移动
  late bool isMove = false;

  final GlobalKey globalKey = GlobalKey();

  /// 内部尺寸 width
  late double w;

  /// 内部尺寸 height
  late double h;

  @override
  void initState() {
    super.initState();

    w = widget.width;
    h = widget.height;
    initPosition = Offset(w / 2, h / 2);

    /// 避免计算后的倾斜，默认为尺寸/2
    position = initPosition;
  }

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
        tiltTransformFinish(event.localPosition);
      },
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: isMove ? 100 : 200),
        tween: Tween<Offset>(
          begin: isMove ? Offset.zero : position,
          end: isMove ? position : initPosition,
        ),
        builder: (context, value, child) {
          print("重载");
          position = value;

          return Transform(
            key: globalKey,
            alignment: Alignment.center,
            transform: tiltTransformStart(),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }

  /// 计算倾斜开始
  Matrix4 tiltTransformStart() {
    final matrix = Matrix4.identity();

    /// 移动位置
    final double x = position.dx;
    final double y = position.dy;

    /// 旋转角度 (中心位置) / 灵敏度
    final double rotateX = -((w / 2 - x) / w);
    final double rotateY = ((h / 2 - y) / h);

    print('X');
    print(rotateY);
    print(y);
    print('Y');
    print(rotateX);
    print(x);

    /// 近大远小效果（适配不同尺寸的组件）
    matrix.setEntry(3, 2, 0.5 / (w > h ? w : h));

    /// 旋转
    matrix.rotateY(rotateX);
    matrix.rotateX(rotateY);

    return matrix;
  }

  /// 计算倾斜结束
  void tiltTransformFinish(Offset offset) {
    setState(() {
      position = offset;
      isMove = false;
    });
  }

  /// 约束范围
  void bindingRange(Offset offset) {
    /// 移动位置
    final double x = offset.dx;
    final double y = offset.dy;

    /// 触发范围阈值
    const double r = 10;

    /// 限制移动范围
    if (x <= w + r && x >= -r && y <= h + r && y >= -r) {
      setState(() {
        position = offset;
        isMove = true;
      });
    }
  }
}
