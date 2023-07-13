import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';
import 'package:flutter_tilt/src/type/tilt_shadow_type.dart';

import 'package:flutter_tilt/src/tilt_container.dart';
import 'package:flutter_tilt/src/gestures_listener.dart';

import 'package:flutter_tilt/src/state/tilt_state.dart';

class Tilt extends StatefulWidget {
  const Tilt({
    Key? key,
    required this.child,
    this.angle = 10,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.isOutsideAreaMove = true,
    this.lightConfig = const LightConfig(),
    this.shadowConfig = const ShadowConfig(),
  }) : super(key: key);

  final Widget child;

  /// 可倾斜角度
  ///
  /// {@template tilt.angle}
  /// 例如：0 会停止不动、180 会翻转...
  ///
  /// 调整该值后，一般还需要调整 [ShadowConfig.distance] 的值，
  /// 保持一种相对正确的阴影关系
  /// {@endtemplate}
  final double angle;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// Clip
  final Clip clipBehavior;

  /// 倾斜过程中区域外是否可以继续移动
  ///
  /// `仅对手势按下后的移动有效`
  /// [GesturesListener] 触发的 [TiltTouchListener.onPointerMove]
  ///
  /// 当触发手势移动的倾斜过程中，
  /// 手势移动到区域外是否可以继续移动。
  ///
  /// * true: 手势触发过程中超出区域可以继续移动
  /// * flase: 超出区域后回到初始状态
  final bool isOutsideAreaMove;

  /// 光源配置
  final LightConfig lightConfig;

  /// 阴影配置
  final ShadowConfig shadowConfig;

  @override
  State<Tilt> createState() => _TiltState();
}

class _TiltState extends State<Tilt> {
  /// 是否初始化
  late bool isInit = false;

  late double width = 0;
  late double height = 0;

  /// 当前坐标的区域进度
  late Offset areaProgress = Offset.zero;

  /// 是否正在移动
  late bool isMove = false;

  @override
  Widget build(BuildContext context) {
    return TiltState(
      isInit: isInit,
      width: width,
      height: height,
      areaProgress: areaProgress,
      isMove: isMove,
      onMove: onGesturesMove,
      onStop: onGesturesStop,
      onResize: onResize,
      child: GesturesListener(
        child: TiltContainer(
          borderRadius: widget.borderRadius,
          clipBehavior: widget.clipBehavior,
          angle: widget.angle,
          lightConfig: widget.lightConfig,
          shadowConfig: widget.shadowConfig,
          child: widget.child,
        ),
      ),
    );
  }

  /// 调整尺寸
  void onResize(Size size) {
    if (isInit) return;
    setState(() {
      isInit = true;
      width = size.width;
      height = size.height;
      areaProgress = p2cAreaProgress(width, height, Offset.zero);
    });
  }

  /// 手势移动触发
  void onGesturesMove(Offset offset) {
    if (widget.isOutsideAreaMove || isInRange(width, height, offset)) {
      setState(() {
        areaProgress = p2cAreaProgress(width, height, offset);
        isMove = true;
      });
    } else {
      onGesturesStop(offset);
    }
  }

  /// 手势停止触发
  void onGesturesStop(Offset offset) {
    setState(() {
      areaProgress = p2cAreaProgress(width, height, offset);
      isMove = false;
    });
  }
}
