import 'dart:async' as async;
import 'package:flutter/widgets.dart';

import 'package:sensors_plus/sensors_plus.dart';

import 'package:flutter_tilt/src/data/tilt_data.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/gestures_listener.dart';
import 'package:flutter_tilt/src/sensors_listener.dart';
import 'package:flutter_tilt/src/state/tilt_state.dart';
import 'package:flutter_tilt/src/tilt_container.dart';
import 'package:flutter_tilt/src/tilt_parallax_container.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';
import 'package:flutter_tilt/src/type/tilt_shadow_type.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';
import 'package:flutter_tilt/src/utils.dart';

/// 倾斜
class Tilt extends TiltContainer {
  /// 倾斜
  ///
  /// 在 [childInner] 中使用 [TiltParallax] 可以达到视差的效果
  const Tilt({
    super.key,
    required super.child,
    super.childLayout = const ChildLayout(),
    this.disable = false,
    this.fps = 60,
    super.border,
    super.borderRadius,
    super.clipBehavior = Clip.antiAlias,
    super.tiltConfig = const TiltConfig(),
    super.lightConfig = const LightConfig(),
    super.shadowConfig = const ShadowConfig(),
    this.onGestureMove,
    this.onGestureLeave,
  });

  /// 全部禁用
  final bool disable;

  /// FPS
  ///
  /// 每秒手势触发帧数，帧数越高越平滑，但性能消耗越高。
  ///
  /// 推荐 60 FPS，如果遭遇性能问题，还可以使用人眼能够接受的 24 FPS
  final int fps;

  /// 手势移动触发
  final TiltCallback? onGestureMove;

  /// 手势离开触发
  final TiltCallback? onGestureLeave;

  @override
  State<Tilt> createState() => _TiltState();
}

class _TiltState extends State<Tilt> {
  Widget get _child => widget.child;
  ChildLayout get _childLayout => widget.childLayout;
  bool get _disable => widget.disable;
  int get _fps => widget.fps;
  BoxBorder? get _border => widget.border;
  BorderRadiusGeometry? get _borderRadius => widget.borderRadius;
  Clip get _clipBehavior => widget.clipBehavior;
  TiltConfig get _tiltConfig => widget.tiltConfig;
  LightConfig get _lightConfig => widget.lightConfig;
  ShadowConfig get _shadowConfig => widget.shadowConfig;
  TiltCallback? get _onGestureMove => widget.onGestureMove;
  TiltCallback? get _onGestureLeave => widget.onGestureLeave;

  /// 初始坐标区域进度
  Offset get _initAreaProgress => _tiltConfig.initial ?? Offset.zero;

  /// 是否初始化
  late bool isInit = false;

  /// 尺寸
  late double width = 0.0, height = 0.0;

  /// 当前坐标的区域进度
  late Offset areaProgress = _initAreaProgress;

  /// 是否正在移动
  bool isMove = false;

  /// 当前手势类型
  GesturesType currentGesturesType = GesturesType.none;

  /// FPS 计时器
  async.Timer? _fpsTimer;

  /// 是否传感器监听
  bool isSensorsListener = true;

  /// 传感器坐标
  late Offset sensorsPosition =
      progressPosition(width, height, _initAreaProgress);

  @override
  void dispose() {
    _fpsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SensorsListener(
      isSensorsListener: isSensorsListener,
      position: sensorsPosition,
      tiltConfig: _tiltConfig,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (_tiltConfig.enableGestureSensors && isSensorsListener) {
            onGesturesSensors(snapshot.data!);
          }
          return TiltState(
            isInit: isInit,
            width: width,
            height: height,
            areaProgress: areaProgress,
            isMove: isMove,
            currentGesturesType: currentGesturesType,
            tiltConfig: _tiltConfig,
            onResize: onResize,
            onMove: onGesturesMove,
            onRevert: onGesturesRevert,
            child: GesturesListener(
              tiltConfig: _tiltConfig,
              child: TiltContainer(
                border: _border,
                borderRadius: _borderRadius,
                clipBehavior: _clipBehavior,
                tiltConfig: _tiltConfig,
                lightConfig: _lightConfig,
                shadowConfig: _shadowConfig,
                childLayout: _childLayout,
                child: _child,
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  /// 调整尺寸
  void onResize(Size size) {
    if (isInit) return;
    setState(() {
      isInit = true;
      width = size.width;
      height = size.height;
      sensorsPosition = progressPosition(width, height, areaProgress);
    });
  }

  /// 手势传感器触发
  void onGesturesSensors(GyroscopeEvent gyroscopeEvent) {
    if (!isInit || _disable) return;
    if (!fpsTimer()) return;
    sensorsPosition +=
        Offset(gyroscopeEvent.y, gyroscopeEvent.x) * _tiltConfig.sensorFactor;
    sensorsPosition = constraintsPosition(width, height, sensorsPosition);
    areaProgress = p2cAreaProgress(
      width,
      height,
      sensorsPosition,
      _tiltConfig.direction,
    );
    isMove = true;
    currentGesturesType = GesturesType.sensors;

    onGestureMove(areaProgress, GesturesType.sensors);
  }

  /// 开启手势传感器
  void enableGesturesSensors(Offset position) {
    /// 同时开启手势 Touch Hover Sensors 时，
    /// 避免 Touch Hover 动画未结束时开启 Sensors，
    /// 和谐共处。
    Future.delayed(_tiltConfig.leaveDuration, () {
      setState(() {
        isSensorsListener = true;
        sensorsPosition = position;
      });
    });
  }

  /// 关闭手势传感器
  void disableGesturesSensors() {
    if (!isSensorsListener) return;
    setState(() {
      isSensorsListener = false;
    });

    onGestureLeave(areaProgress, GesturesType.sensors);
  }

  /// 手势移动触发
  ///
  /// [offset] 当前坐标
  void onGesturesMove(Offset offset, GesturesType gesturesType) {
    if (!isInit || _disable) return;
    if (!fpsTimer()) return;
    if (_tiltConfig.enableOutsideAreaMove || isInRange(width, height, offset)) {
      setState(() {
        areaProgress = p2cAreaProgress(
          width,
          height,
          offset,
          _tiltConfig.direction,
        );
        isMove = true;
        currentGesturesType = gesturesType;
      });

      disableGesturesSensors();
      onGestureMove(areaProgress, gesturesType);
    } else {
      onGesturesRevert(offset, gesturesType);
    }
  }

  /// 手势复原触发
  ///
  /// [offset] 当前坐标
  void onGesturesRevert(Offset offset, GesturesType gesturesType) {
    if (!isInit || _disable) return;

    /// 是否还原的取值
    final Offset position = _tiltConfig.enableRevert
        ? progressPosition(width, height, _initAreaProgress)
        : offset;

    setState(() {
      areaProgress = p2cAreaProgress(
        width,
        height,
        position,
        _tiltConfig.direction,
      );
      isMove = false;
      currentGesturesType = gesturesType;
    });

    enableGesturesSensors(position);
    onGestureLeave(areaProgress, gesturesType);
  }

  /// FPS
  bool fpsTimer() {
    if (_fpsTimer == null) {
      _fpsTimer = async.Timer(
        Duration(milliseconds: (1 / _fps * 1000) ~/ 1),
        () => _fpsTimer = null,
      );
      return true;
    } else {
      return false;
    }
  }

  /// onGestureMove
  ///
  /// - [areaProgress] 当前坐标的区域进度
  void onGestureMove(Offset areaProgress, GesturesType gesturesType) {
    if (_onGestureMove != null) {
      _onGestureMove!(
        TiltData(
          isInit: isInit,
          width: width,
          height: height,
          areaProgress: areaProgress,
          tiltConfig: _tiltConfig,
        ).data,
        gesturesType,
      );
    }
  }

  /// onGestureLeave
  ///
  /// - [areaProgress] 当前坐标的区域进度
  void onGestureLeave(Offset areaProgress, GesturesType gesturesType) {
    if (_onGestureLeave != null) {
      _onGestureLeave!(
        TiltData(
          isInit: isInit,
          width: width,
          height: height,
          areaProgress: areaProgress,
          tiltConfig: _tiltConfig,
        ).data,
        gesturesType,
      );
    }
  }
}

/// 倾斜视差
class TiltParallax extends TiltParallaxContainer {
  /// 倾斜视差
  ///
  /// 一般用作视差的 Widget
  ///
  /// 只能在 [Tilt.childInner] 中使用
  const TiltParallax({
    super.key,
    required super.child,
    super.size = const Offset(10.0, 10.0),
    super.filterQuality,
  });
}
