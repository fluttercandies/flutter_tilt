import 'dart:async' as async;

import 'package:flutter/widgets.dart';

import 'config/tilt_config.dart';
import 'config/tilt_light_config.dart';
import 'config/tilt_shadow_config.dart';
import 'data/tilt_data.dart';
import 'enums.dart';
import 'state/tilt_state.dart';
import 'utils.dart';
import 'widget/gestures_listener.dart';
import 'widget/tilt_container.dart';
import 'widget/tilt_parallax_container.dart';
import 'widget/tilt_stream_builder.dart';

/// Tilt
/// 倾斜
class Tilt extends TiltContainer {
  /// Tilt
  /// 倾斜
  ///
  /// - [childLayout] : Other child layouts. e.g. [TiltParallax] parallax inner, outer, behind.
  /// - [tiltStreamController] : `StreamController<TiltStreamModel>.broadcast()` to control the tilt.
  /// - [disable] : Disable all effects.
  /// - [fps] : Gesture triggered frames.
  /// - [border] : BoxDecoration border.
  /// - [borderRadius] : BoxDecoration borderRadius.
  /// - [clipBehavior] : Flutter clipBehavior.
  /// - [tiltConfig] : Tilt effect config.
  /// - [lightShadowMode] : Light & Shadow Mode
  /// - [lightConfig] : Light effect config.
  /// - [shadowConfig] : Shadow effect config.
  /// - [onGestureMove] : Gesture move callback.
  /// - [onGestureLeave] : Gesture leave callback.
  ///
  /// ------
  ///
  /// - [childLayout] : 其他 child 布局。例如：位于 child 内部、外部、后面的视差布局 [TiltParallax]。
  /// - [tiltStreamController] : 通过 `StreamController<TiltStreamModel>.broadcast()` 来自定义控制倾斜。
  /// - [disable] : 禁用所有效果。
  /// - [fps] : 手势触发的帧数。
  /// - [border] : BoxDecoration 边框样式。
  /// - [borderRadius] : BoxDecoration 边框圆角半径。
  /// - [clipBehavior] : Flutter clipBehavior。
  /// - [tiltConfig] : 倾斜效果配置。
  /// - [lightShadowMode] : 光影 Mode
  /// - [lightConfig] : 光照效果配置。
  /// - [shadowConfig] : 阴影效果配置。
  /// - [onGestureMove] : 手势移动的回调触发。
  /// - [onGestureLeave] : 手势离开的回调触发。
  ///
  const Tilt({
    super.key,
    required super.child,
    super.childLayout = const ChildLayout(),
    this.tiltStreamController,
    this.disable = false,
    this.fps = 60,
    super.border,
    super.borderRadius,
    super.clipBehavior = Clip.antiAlias,
    super.tiltConfig = const TiltConfig(),
    super.lightShadowMode,
    super.lightConfig = const LightConfig(),
    super.shadowConfig = const ShadowConfig(),
    this.onGestureMove,
    this.onGestureLeave,
  });

  /// Tilt Stream Controller
  ///
  /// `StreamController<TiltStreamModel>.broadcast()` to control the tilt.
  ///
  /// ------
  ///
  /// 通过 `StreamController<TiltStreamModel>.broadcast()` 来自定义控制倾斜。
  ///
  final async.StreamController<TiltStreamModel>? tiltStreamController;

  /// Disable all effects.
  ///
  /// ------
  ///
  /// 禁用所有效果。
  final bool disable;

  /// Gesture triggered frames.
  ///
  /// ------
  ///
  /// 手势触发的帧数。
  final int fps;

  /// Gesture move callback.
  ///
  /// ------
  ///
  /// 手势移动的回调触发。
  final TiltCallback? onGestureMove;

  /// Gesture leave callback.
  ///
  /// ------
  ///
  /// 手势离开的回调触发。
  final TiltCallback? onGestureLeave;

  @override
  State<Tilt> createState() => _TiltState();
}

class _TiltState extends State<Tilt> {
  Widget get _child => widget.child;
  ChildLayout get _childLayout => widget.childLayout;
  async.StreamController<TiltStreamModel>? get _tiltStreamController =>
      widget.tiltStreamController;
  bool get _disable => widget.disable;
  int get _fps => widget.fps;
  BoxBorder? get _border => widget.border;
  BorderRadiusGeometry? get _borderRadius => widget.borderRadius;
  Clip get _clipBehavior => widget.clipBehavior;
  TiltConfig get _tiltConfig => widget.tiltConfig;
  LightShadowMode get _lightShadowMode => widget.lightShadowMode;
  LightConfig get _lightConfig => widget.lightConfig;
  ShadowConfig get _shadowConfig => widget.shadowConfig;
  TiltCallback? get _onGestureMove => widget.onGestureMove;
  TiltCallback? get _onGestureLeave => widget.onGestureLeave;

  /// 初始坐标区域进度
  Offset get _initAreaProgress => _tiltConfig.initial ?? Offset.zero;

  /// 是否初始化
  bool isInit = false;

  /// 尺寸
  double width = 0.0, height = 0.0;

  /// 当前坐标的区域进度
  late Offset areaProgress = _initAreaProgress;

  /// 是否正在移动
  bool isMove = false;

  /// 当前手势类型
  GesturesType currentGesturesType = GesturesType.none;

  /// FPS 计时器
  async.Timer? _fpsTimer;

  /// 默认 TiltStreamController
  ///
  /// [widget.tiltStreamController] 为 null 时使用
  late async.StreamController<TiltStreamModel> defaultTiltStreamController;

  /// 当前坐标
  late Offset currentPosition = Utils.progressPosition(
    width,
    height,
    _initAreaProgress,
  );

  @override
  void initState() {
    super.initState();
    defaultTiltStreamController =
        async.StreamController<TiltStreamModel>.broadcast();
  }

  @override
  void dispose() {
    _fpsTimer?.cancel();
    defaultTiltStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async.StreamController<TiltStreamModel> tiltStreamController =
        _tiltStreamController ?? defaultTiltStreamController;

    return GesturesListener(
      tiltStreamController: tiltStreamController,
      tiltConfig: _tiltConfig,
      child: TiltStreamBuilder(
        tiltStreamController: tiltStreamController,
        position: currentPosition,
        disable: _disable,
        fps: _fps,
        tiltConfig: _tiltConfig,
        builder: (context, snapshot) {
          onGesturesStream(snapshot.data);
          return TiltState(
            isInit: isInit,
            width: width,
            height: height,
            areaProgress: areaProgress,
            isMove: isMove,
            currentGesturesType: currentGesturesType,
            tiltConfig: _tiltConfig,
            onResize: onResize,
            child: TiltContainer(
              border: _border,
              borderRadius: _borderRadius,
              clipBehavior: _clipBehavior,
              tiltConfig: _tiltConfig,
              lightShadowMode: _lightShadowMode,
              lightConfig: _lightConfig,
              shadowConfig: _shadowConfig,
              childLayout: _childLayout,
              child: _child,
            ),
          );
        },
      ),
    );
  }

  /// 调整尺寸及初始参数
  void onResize(Size size) {
    final Size oldSize = Size(width, height);
    if (oldSize != size) {
      isInit = true;
      width = size.width;
      height = size.height;
      setState(() {
        currentPosition = Utils.progressPosition(
          width,
          height,
          _initAreaProgress,
        );
      });
    }
  }

  /// 手势 Stream 触发
  void onGesturesStream(TiltStreamModel? tiltStreamModel) {
    if (tiltStreamModel == null) return;
    if (tiltStreamModel.gesturesType == GesturesType.none) return;
    if (!isInit || _disable) return;
    switch (tiltStreamModel.gesturesType) {
      case GesturesType.none:
        break;
      case GesturesType.touch || GesturesType.hover || GesturesType.controller:
        if (tiltStreamModel.gestureUse) {
          onGesturesMove(
            tiltStreamModel.position,
            tiltStreamModel.gesturesType,
          );
        } else {
          onGesturesRevert(
            tiltStreamModel.position,
            tiltStreamModel.gesturesType,
          );
        }
      case GesturesType.sensors:
        // Sensors 只会触发 onGestureMove，不会触发 onGestureLeave
        currentPosition += tiltStreamModel.position * _tiltConfig.sensorFactor;
        onGesturesSensorsRevert();
        currentPosition = Utils.constraintsPosition(
          width,
          height,
          currentPosition,
        );
        onGesturesMove(currentPosition, tiltStreamModel.gesturesType);
    }
  }

  /// 手势移动触发
  ///
  /// [offset] 当前坐标
  void onGesturesMove(Offset offset, GesturesType gesturesType) {
    if (!isInit || _disable) return;
    if (!fpsTimer()) return;
    if (_tiltConfig.enableOutsideAreaMove ||
        Utils.isInRange(width, height, offset)) {
      currentPosition = offset;
      areaProgress = Utils.p2cAreaProgress(
        width,
        height,
        offset,
        _tiltConfig.direction,
      );
      isMove = true;
      currentGesturesType = gesturesType;
      onGestureMove(areaProgress, gesturesType);
    } else {
      onGesturesRevert(offset, gesturesType);
    }
  }

  /// 手势复原触发
  ///
  /// [offset] 当前坐标
  void onGesturesRevert(Offset offset, GesturesType gesturesType) {
    if (!isInit || _disable || !isMove) return;

    /// 是否还原的取值
    final Offset position = _tiltConfig.enableRevert
        ? Utils.progressPosition(width, height, _initAreaProgress)
        : currentPosition;
    currentPosition = position;
    areaProgress = Utils.p2cAreaProgress(
      width,
      height,
      position,
      _tiltConfig.direction,
    );
    isMove = false;
    currentGesturesType = gesturesType;
    onGestureLeave(areaProgress, gesturesType);
  }

  /// 手势传感器复原触发
  ///
  /// Sensors 只会触发 onGestureMove，不会触发 onGestureLeave
  void onGesturesSensorsRevert() {
    if (!_tiltConfig.enableSensorRevert) return;

    /// 默认坐标
    final Offset initPosition = Utils.progressPosition(
      width,
      height,
      _initAreaProgress,
    );

    /// 还原
    currentPosition -= Offset(
          currentPosition.dx - initPosition.dx,
          currentPosition.dy - initPosition.dy,
        ) *
        _tiltConfig.sensorRevertFactor;
  }

  /// FPS
  bool fpsTimer() {
    if (_fpsTimer == null) {
      _fpsTimer = async.Timer(
        Duration(milliseconds: (1000 / _fps) ~/ 1),
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
      WidgetsBinding.instance.endOfFrame.then((_) {
        if (mounted) {
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
      });
    }
  }

  /// onGestureLeave
  ///
  /// - [areaProgress] 当前坐标的区域进度
  void onGestureLeave(Offset areaProgress, GesturesType gesturesType) {
    if (_onGestureLeave != null) {
      WidgetsBinding.instance.endOfFrame.then((_) {
        if (mounted) {
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
      });
    }
  }
}

/// TiltParallax
/// 倾斜视差
class TiltParallax extends TiltParallaxContainer {
  /// TiltParallax
  /// 倾斜视差
  ///
  /// Parallax that can only be used in [Tilt.childLayout].
  ///
  /// - [size] : Parallax size.
  /// - [filterQuality] : Flutter FilterQuality.
  ///
  /// ------
  ///
  /// 只能在 [Tilt.childLayout] 中使用的视差效果。
  ///
  /// - [size] : 视差大小。
  /// - [filterQuality] : Flutter FilterQuality。
  ///
  const TiltParallax({
    super.key,
    required super.child,
    super.size = const Offset(10.0, 10.0),
    super.filterQuality,
  });
}
