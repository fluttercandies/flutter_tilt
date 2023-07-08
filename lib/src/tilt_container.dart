import 'package:flutter/material.dart';

import 'utils.dart';

import 'light.dart';

import 'states/tilt_state.dart';

class TiltContainer extends StatefulWidget {
  const TiltContainer({
    super.key,
    required this.child,
    this.lightDirection = LightDirection.around,
  });

  final Widget child;
  final LightDirection lightDirection;

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
      duration: Duration(milliseconds: isMove ? 100 : 200),
      tween: Tween<Offset>(
        begin: isMove ? Offset.zero : position,
        end: isMove ? position : initPosition,
      ),
      builder: (context, value, child) {
        print("TweenAnimationBuilder Build");
        print(value);

        position = value;

        return Transform(
          alignment: Alignment.center,
          transform: tiltTransform(w, h, value.dx, value.dy),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
    );
  }
}
