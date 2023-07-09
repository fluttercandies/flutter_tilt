import 'package:flutter/material.dart';

import 'utils.dart';

import 'tilt_light.dart';
import 'tilt_shadow.dart';

import 'state/tilt_state.dart';

class TiltContainer extends StatefulWidget {
  const TiltContainer({
    super.key,
    required this.child,
    this.borderRadius,
    required this.lightColor,
    required this.lightDirection,
    required this.islightReverse,
    required this.shadowColor,
  });

  final Widget child;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 光颜色
  final Color lightColor;

  /// 光源方向
  final LightDirection lightDirection;

  /// 光源是否反向
  final bool islightReverse;

  /// 阴影颜色
  final Color shadowColor;

  @override
  State<TiltContainer> createState() => _TiltContainerState();
}

class _TiltContainerState extends State<TiltContainer> {
  /// 初始的坐标，避免计算后的倾斜，默认为尺寸/2
  late Offset initPosition = Offset(w / 2, h / 2);

  /// Width
  late double w;

  /// Height
  late double h;

  /// 坐标位置
  late Offset position;

  /// 是否正在移动
  late bool isMove;

  /// 是否有光源
  late bool isLight = widget.lightDirection != LightDirection.none;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final TiltState tiltState = TiltState.of(context)!;
    w = tiltState.width;
    h = tiltState.height;
    position = tiltState.position;
    isMove = tiltState.isMove;
  }

  @override
  Widget build(BuildContext context) {
    print("TiltContainer Build");

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: isMove ? 100 : 300),
      tween: Tween<Offset>(
        begin: isMove ? Offset.zero : position,
        end: isMove ? position : initPosition,
      ),
      builder: (context, value, child) {
        print("TweenAnimationBuilder Build");
        print(value);

        position = value;

        return IgnorePointer(
          child: Transform(
            alignment: Alignment.center,
            transform: tiltTransform(w, h, value.dx, value.dy),
            child: TiltShadow(
              width: w,
              height: h,
              position: value,
              borderRadius: widget.borderRadius,
              shadowColor: widget.shadowColor,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  /// Body
                  Container(
                    width: w,
                    height: h,
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: child,
                  ),

                  /// Light
                  isLight
                      ? TiltLight(
                          width: w,
                          height: h,
                          position: value,
                          borderRadius: widget.borderRadius,
                          lightColor: widget.lightColor,
                          lightDirection: widget.lightDirection,
                          islightReverse: widget.islightReverse,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
