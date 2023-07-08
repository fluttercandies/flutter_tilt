import 'package:flutter/material.dart';

import 'light.dart';

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
      onPointerUp: (event) {
        tiltTransformFinish(event.localPosition);
      },
      onPointerCancel: (event) {
        tiltTransformFinish(event.localPosition);
      },
      behavior: HitTestBehavior.deferToChild,
      child: MouseRegion(
        onHover: (event) {
          bindingRange(event.localPosition);
        },
        onExit: (event) {
          tiltTransformFinish(event.localPosition);
        },
        cursor: MouseCursor.defer,
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

            return Transform(
              key: globalKey,
              alignment: Alignment.center,
              transform: tiltTransformStart(),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: [
                    /// Body
                    child ?? const SizedBox(),

                    /// Light
                    isLight
                        ? Light(
                            width: w,
                            height: h,
                            position: value,
                            lightDirection: widget.lightDirection,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            );
          },
          child: widget.child,
        ),
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
    } else {
      tiltTransformFinish(position);
    }
  }
}
