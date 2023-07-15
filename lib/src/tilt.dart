import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';
import 'package:flutter_tilt/src/type/tilt_shadow_type.dart';

import 'package:flutter_tilt/src/tilt_container.dart';
import 'package:flutter_tilt/src/gestures_listener.dart';

import 'package:flutter_tilt/src/state/tilt_state.dart';

class Tilt extends StatefulWidget {
  const Tilt({
    Key? key,
    required this.child,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.tiltConfig = const TiltConfig(),
    this.lightConfig = const LightConfig(),
    this.shadowConfig = const ShadowConfig(),
  }) : super(key: key);

  final Widget child;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// Clip
  final Clip clipBehavior;

  /// 倾斜配置
  final TiltConfig tiltConfig;

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

  /// 倾斜配置
  late final TiltConfig _tiltConfig = widget.tiltConfig;

  /// 光源配置
  late final LightConfig _lightConfig = widget.lightConfig;

  /// 阴影配置
  late final ShadowConfig _shadowConfig = widget.shadowConfig;

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
          tiltConfig: _tiltConfig,
          lightConfig: _lightConfig,
          shadowConfig: _shadowConfig,
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
      areaProgress = p2cAreaProgress(
        width,
        height,
        Offset.zero,
        _tiltConfig.direction,
      );
    });
  }

  /// 手势移动触发
  void onGesturesMove(Offset offset) {
    if (!isInit) return;
    if (_tiltConfig.isOutsideAreaMove || isInRange(width, height, offset)) {
      setState(() {
        areaProgress = p2cAreaProgress(
          width,
          height,
          offset,
          _tiltConfig.direction,
        );
        isMove = true;
      });
    } else {
      onGesturesStop(offset);
    }
  }

  /// 手势停止触发
  void onGesturesStop(Offset offset) {
    if (!isInit) return;
    setState(() {
      areaProgress = p2cAreaProgress(
        width,
        height,
        offset,
        _tiltConfig.direction,
      );
      isMove = false;
    });
  }
}
