import 'package:flutter/widgets.dart';

import 'utils.dart';

import 'tilt_light.dart';
import 'tilt_container.dart';
import 'gestures_listener.dart';

import 'states/tilt_state.dart';

class Tilt extends StatefulWidget {
  const Tilt({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.borderRadius,
    this.lightColor = const Color(0xFFFFFFFF),
    this.lightDirection = LightDirection.around,
    this.islightReverse = false,
  });

  final double width;
  final double height;
  final Widget child;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 光颜色
  final Color lightColor;

  /// 光源方向
  final LightDirection lightDirection;

  /// 光源是否反向
  final bool islightReverse;

  @override
  State<Tilt> createState() => _TiltState();
}

class _TiltState extends State<Tilt> {
  /// 初始的坐标，避免计算后的倾斜，默认为尺寸/2
  late Offset initPosition = Offset(w / 2, h / 2);

  /// Width
  late double w = widget.width;

  /// Height
  late double h = widget.height;

  /// 坐标位置
  late Offset position = initPosition;

  /// 是否正在移动
  late bool isMove = false;

  @override
  Widget build(BuildContext context) {
    print('Tilt Build');

    return TiltState(
      height: h,
      width: w,
      position: position,
      isMove: isMove,
      onMove: onGesturesMove,
      onStop: onGesturesStop,
      child: GesturesListener(
        child: TiltContainer(
          borderRadius: widget.borderRadius,
          lightColor: widget.lightColor,
          lightDirection: widget.lightDirection,
          islightReverse: widget.islightReverse,
          child: widget.child,
        ),
      ),
    );
  }

  /// 手势移动触发
  void onGesturesMove(Offset offset) {
    if (isInRange(w, h, offset)) {
      setState(() {
        position = offset;
        isMove = true;
      });
    } else {
      onGesturesStop(position);
    }
  }

  /// 手势停止触发
  void onGesturesStop(Offset offset) {
    setState(() {
      position = offset;
      isMove = false;
    });
  }
}
