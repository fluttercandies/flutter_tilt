import 'dart:math';
import 'package:flutter/material.dart';

class Tilt extends StatefulWidget {
  const Tilt({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.z = 0,
    this.lightDirection = LightDirection.around,
  });

  final Widget child;
  final double width;
  final double height;
  final double z;

  /// 光源位置
  final LightDirection lightDirection;

  @override
  State<Tilt> createState() => _TiltState();
}

class _TiltState extends State<Tilt> {
  /// 移动的位置
  late Offset _position;

  /// 初始的尺寸
  late Offset initPosition;

  /// 是否正在移动
  late bool isMove = false;

  /// 是否有光源
  late bool isLight = widget.lightDirection != LightDirection.none;

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

    print("w:$w, h:$h");

    /// 避免计算后的倾斜，默认为尺寸/2
    initPosition = Offset(w / 2, h / 2);
    _position = initPosition;
  }

  @override
  Widget build(BuildContext context) {
    print("Tilt 重载");

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
          begin: isMove ? Offset.zero : _position,
          end: isMove ? _position : initPosition,
        ),
        builder: (context, value, child) {
          print("TweenAnimationBuilder 重载");
          print(value);

          _position = value;

          /// 移动位置
          final double x = value.dx;
          final double y = value.dy;

          return Transform(
            key: globalKey,
            alignment: Alignment.center,
            transform: tiltTransformStart(),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Stack(children: [
                /// Body
                child ?? const SizedBox(),

                /// Light 1.5 为扩大尺寸的倍数
                isLight
                    ? Positioned(
                        left: x - w / 2 * 1.5,
                        top: y - h / 2 * 1.5,
                        width: w * 1.5,
                        height: h * 1.5,
                        child: Light(
                          width: w * 1.5,
                          height: h * 1.5,
                          position: _position,
                          lightDirection: widget.lightDirection,
                        ),
                      )
                    : const SizedBox(),
              ]),
            ),
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
    final double x = _position.dx;
    final double y = _position.dy;

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

  /// 计算倾斜结束
  void tiltTransformFinish(Offset position) {
    setState(() {
      position = position;
      isMove = false;
    });
  }

  /// 约束范围
  void bindingRange(Offset position) {
    /// 移动位置
    final double x = position.dx;
    final double y = position.dy;

    /// 触发范围阈值
    const double r = 10;

    /// 限制移动范围
    if (x <= w + r && x >= -r && y <= h + r && y >= -r) {
      setState(() {
        _position = position;
        isMove = true;
      });
    }
  }
}

/// 光线方向
enum LightDirection {
  none,
  around,
  all,
  top,
  bottom,
  left,
  right,
  center,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  xCenter,
  yCenter,
}

/// 光
class Light extends StatelessWidget {
  const Light({
    super.key,
    required this.width,
    required this.height,
    required this.position,
    required this.lightDirection,
  });

  final double width;
  final double height;
  final Offset position;
  final LightDirection lightDirection;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity(lightDirection),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 0.5,
            colors: [
              Colors.white.withAlpha(60),
              Colors.white.withAlpha(0),
            ],
            stops: const [0.01, 0.99],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
  }

  /// 透明度计算
  double opacity(LightDirection lightDirection) {
    /// 移动位置
    final double x = position.dx;
    final double y = position.dy;

    /// 去掉被扩大的
    final double w = width / 1.5;
    final double h = height / 1.5;

    /// 旋转角度 (中心位置) / 灵敏度
    final double rotateX = -((w / 2 - x) / w);
    final double rotateY = ((h / 2 - y) / h);

    print("opacity");
    print(rotateX);
    print(rotateY);

    /// 临时位置
    late double tempRotateX = rotateX;
    late double tempRotateY = rotateY;

    /// 透明度
    late double opacity = 0;

    switch (lightDirection) {
      case LightDirection.none:
      case LightDirection.around:
        // 两点间的距离，中心 (0,0) 到坐标 (x2,y2) 的位置，sqrt((x1-x2)²+(y1-y2)²)
        final double distance =
            sqrt(tempRotateX * tempRotateX + tempRotateY * tempRotateY);
        opacity = 0.5 + distance;
      case LightDirection.all:
        opacity = 1;
      case LightDirection.top:
        opacity = rotateY * 2;
      case LightDirection.bottom:
        opacity = -rotateY * 2;
      case LightDirection.left:
        opacity = -rotateX * 2;
      case LightDirection.right:
        opacity = rotateX * 2;
      case LightDirection.center:
        // 两点间的距离，中心 (0,0) 到坐标 (x2,y2) 的位置，sqrt((x1-x2)²+(y1-y2)²)
        final double distance =
            sqrt(tempRotateX * tempRotateX + tempRotateY * tempRotateY);
        opacity = 1 - distance;
      case LightDirection.topLeft:
        opacity = -(rotateX - rotateY) * 2;
      case LightDirection.topRight:
        opacity = (rotateX + rotateY) * 2;
      case LightDirection.bottomLeft:
        opacity = -(rotateX + rotateY) * 2;
      case LightDirection.bottomRight:
        opacity = (rotateX - rotateY) * 2;
      case LightDirection.xCenter:
        if (rotateY < 0) tempRotateY = -rotateY;
        opacity = (1 - tempRotateY);
      case LightDirection.yCenter:
        if (rotateX < 0) tempRotateX = -rotateX;
        opacity = (1 - tempRotateX);
    }

    if (opacity < 0) opacity = 0;
    if (opacity > 1) opacity = 1;

    return opacity;
  }
}
