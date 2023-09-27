import 'dart:async' as async;
import 'package:flutter/widgets.dart';

import 'utils.dart';
import 'enums.dart';
import 'gestures_listener.dart';
import 'tilt_stream_builder.dart';
import 'tilt_container.dart';
import 'tilt_parallax_container.dart';
import 'data/tilt_data.dart';
import 'state/tilt_state.dart';
import 'config/tilt_light_config.dart';
import 'config/tilt_shadow_config.dart';
import 'config/tilt_config.dart';

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
  bool isInit = false;

  /// 尺寸
  double width = 0.1, height = 0.1;

  /// 当前坐标的区域进度
  late Offset areaProgress = _initAreaProgress;

  /// 是否正在移动
  bool isMove = false;

  /// 当前手势类型
  GesturesType currentGesturesType = GesturesType.none;

  /// FPS 计时器
  async.Timer? _fpsTimer;

  /// Touch 和 Hover 的 TiltStreamController
  late async.StreamController<TiltStream> tiltStreamController;

  /// 当前坐标
  late Offset currentPosition =
      progressPosition(width, height, _initAreaProgress);

  @override
  void initState() {
    super.initState();
    tiltStreamController = async.StreamController<TiltStream>.broadcast();
  }

  @override
  void dispose() {
    _fpsTimer?.cancel();
    tiltStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GesturesListener(
      tiltStreamController: tiltStreamController,
      tiltConfig: _tiltConfig,
      child: TiltStreamBuilder(
        tiltStreamController: tiltStreamController,
        position: currentPosition,
        disable: _disable,
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
    width = size.width;
    height = size.height;

    if (!isInit) {
      isInit = true;
      setState(() {
        currentPosition = progressPosition(width, height, _initAreaProgress);
      });
    }
  }

  /// 手势 Stream 触发
  void onGesturesStream(TiltStream? tiltStream) {
    if (tiltStream == null) return;
    if (tiltStream.gesturesType == GesturesType.none) return;
    if (!isInit || _disable) return;
    switch (tiltStream.gesturesType) {
      case GesturesType.touch:
        if (tiltStream.enableRevert ?? true) {
          onGesturesRevert(tiltStream.position, tiltStream.gesturesType);
        } else {
          onGesturesMove(tiltStream.position, tiltStream.gesturesType);
        }
        break;
      case GesturesType.hover:
        if (tiltStream.enableRevert ?? true) {
          onGesturesRevert(tiltStream.position, tiltStream.gesturesType);
        } else {
          onGesturesMove(tiltStream.position, tiltStream.gesturesType);
        }
        break;
      case GesturesType.sensors:
        // Sensors 只会触发 onGestureMove，不会触发 onGestureLeave
        currentPosition += tiltStream.position * _tiltConfig.sensorFactor;
        onGesturesSensorsRevert();
        currentPosition = constraintsPosition(width, height, currentPosition);
        onGesturesMove(currentPosition, tiltStream.gesturesType);
        break;
      case GesturesType.none:
        break;
    }
  }

  /// 手势移动触发
  ///
  /// [offset] 当前坐标
  void onGesturesMove(Offset offset, GesturesType gesturesType) {
    if (!isInit || _disable) return;
    if (!fpsTimer()) return;
    if (_tiltConfig.enableOutsideAreaMove || isInRange(width, height, offset)) {
      currentPosition = offset;
      areaProgress = p2cAreaProgress(
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
    if (!isInit || _disable) return;

    /// 是否还原的取值
    final Offset position = _tiltConfig.enableRevert
        ? progressPosition(width, height, _initAreaProgress)
        : currentPosition;
    currentPosition = position;
    areaProgress = p2cAreaProgress(
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
    final Offset initPosition =
        progressPosition(width, height, _initAreaProgress);

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
