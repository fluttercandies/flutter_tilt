import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';

import 'package:flutter_tilt/src/tilt_light.dart';
import 'package:flutter_tilt/src/tilt_container.dart';
import 'package:flutter_tilt/src/gestures_listener.dart';

import 'package:flutter_tilt/src/state/tilt_state.dart';

class Tilt extends StatefulWidget {
  const Tilt({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.borderRadius,
    this.sensitivity = 0.2,
    this.lightColor = const Color(0xFFFFFFFF),
    this.lightIntensity = 80,
    this.lightDirection = LightDirection.around,
    this.islightReverse = false,
    this.shadowColor = const Color(0xFF9E9E9E),
    this.shadowDistance = 0.4,
    this.shadowSpreadRadius = 0.5,
    this.shadowBlurRadius = 100.0,
  });

  final double width;
  final double height;
  final Widget child;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 倾斜灵敏度
  ///
  /// 调整该值后，一般还需要调整 [shadowDistance] 的值，
  /// 保持一种相对正确的阴影关系
  ///
  /// 为 0 时将会停止不动
  final double sensitivity;

  /// 光源颜色
  final Color lightColor;

  /// 光源强度
  ///
  /// min: 0 max: 255
  ///
  /// 为 0 时将没有光源
  final int lightIntensity;

  /// 光源方向
  final LightDirection lightDirection;

  /// 光源是否反向
  final bool islightReverse;

  /// 阴影颜色
  final Color shadowColor;

  /// 阴影距离
  ///
  /// 为 0 时将没有阴影
  final double shadowDistance;

  /// 阴影扩散半径
  final double shadowSpreadRadius;

  /// 阴影模糊半径
  final double shadowBlurRadius;

  @override
  State<Tilt> createState() => _TiltState();
}

class _TiltState extends State<Tilt> {
  late double width = widget.width;
  late double height = widget.height;

  /// 初始的坐标
  late Offset initPosition = centerPosition(width, height);

  /// 坐标位置
  late Offset position = initPosition;

  /// 是否正在移动
  late bool isMove = false;

  @override
  Widget build(BuildContext context) {
    return TiltState(
      position: position,
      isMove: isMove,
      onMove: onGesturesMove,
      onStop: onGesturesStop,
      child: GesturesListener(
        child: TiltContainer(
          width: width,
          height: height,
          borderRadius: widget.borderRadius,
          sensitivity: widget.sensitivity,
          lightColor: widget.lightColor,
          lightIntensity: widget.lightIntensity,
          lightDirection: widget.lightDirection,
          islightReverse: widget.islightReverse,
          shadowColor: widget.shadowColor,
          shadowDistance: widget.shadowDistance,
          shadowSpreadRadius: widget.shadowSpreadRadius,
          shadowBlurRadius: widget.shadowBlurRadius,
          child: widget.child,
        ),
      ),
    );
  }

  /// 手势移动触发
  void onGesturesMove(Offset offset) {
    if (isInRange(width, height, offset)) {
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
