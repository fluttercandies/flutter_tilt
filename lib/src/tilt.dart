import 'dart:async' as async;
import 'package:flutter/widgets.dart';

import 'config/tilt_config.dart';
import 'config/tilt_light_config.dart';
import 'config/tilt_shadow_config.dart';
import 'enums.dart';
import 'internal/controllers/fps_timer_controller.dart';
import 'internal/controllers/tilt_gestures_controller.dart';
import 'internal/provider/tilt_provider.dart';
import 'internal/tilt_data.dart';
import 'models/tilt_stream_model.dart';
import 'utils.dart';
import 'widgets/gestures_listener.dart';
import 'widgets/tilt_container.dart';
import 'widgets/tilt_parallax_container.dart';
import 'widgets/tilt_stream_builder.dart';

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
    this.fps = 120,
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
  /// 初始坐标区域进度
  Offset get _initAreaProgress => widget.tiltConfig.initial ?? Offset.zero;

  /// 是否初始化
  bool _isInit = false;

  /// 尺寸
  double _width = 0.0, _height = 0.0;

  /// 当前坐标的区域进度
  late Offset _areaProgress = _initAreaProgress;

  /// 是否正在移动
  bool _isMove = false;

  /// 当前手势类型
  GesturesType _currentGesturesType = GesturesType.none;

  /// 倾斜手势控制器
  late TiltGesturesController _tiltGesturesController;

  /// 默认 TiltStreamController
  ///
  /// [widget.tiltStreamController] 为 null 时使用
  final async.StreamController<TiltStreamModel> _kDefaultTiltStreamController =
      async.StreamController<TiltStreamModel>.broadcast();

  late FpsTimerController _fpsTimerController;

  /// 当前坐标
  late Offset _currentPosition = Utils.progressPosition(
    _width,
    _height,
    _initAreaProgress,
  );

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    _kDefaultTiltStreamController.close();
    _fpsTimerController.dispose();
    _tiltGesturesController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Tilt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldReinitControllers(oldWidget)) {
      _initControllers(oldWidget: oldWidget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GesturesListener(
      tiltGesturesController: _tiltGesturesController,
      child: TiltStreamBuilder(
        tiltGesturesController: _tiltGesturesController,
        builder: (context, snapshot) {
          _handleGesturesStream(snapshot.data);
          return TiltProvider(
            isInit: _isInit,
            width: _width,
            height: _height,
            areaProgress: _areaProgress,
            isMove: _isMove,
            currentGesturesType: _currentGesturesType,
            tiltConfig: widget.tiltConfig,
            onResize: _onResize,
            child: TiltContainer(
              border: widget.border,
              borderRadius: widget.borderRadius,
              clipBehavior: widget.clipBehavior,
              tiltConfig: widget.tiltConfig,
              lightShadowMode: widget.lightShadowMode,
              lightConfig: widget.lightConfig,
              shadowConfig: widget.shadowConfig,
              childLayout: widget.childLayout,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }

  /// 初始化控制器
  ///
  /// - [oldWidget] 旧 Wdiget 一般用于 [didUpdateWidget]
  void _initControllers({Tilt? oldWidget}) {
    /// 是否需要取消 [TiltGesturesController] 中的手势协调器，避免泄露
    if (oldWidget != null && oldWidget.tiltConfig != widget.tiltConfig) {
      _tiltGesturesController.cancelGesturesHarmonizerTimer();
    }

    /// 初始化 TiltGesturesController
    final tiltStreamController =
        widget.tiltStreamController ?? _kDefaultTiltStreamController;
    _tiltGesturesController = TiltGesturesController(
      tiltStreamController: tiltStreamController,
      disable: widget.disable,
      fps: widget.fps,
      tiltConfig: widget.tiltConfig,
      initialPosition: _currentPosition,
    );

    /// 初始化 FpsTimerController
    _fpsTimerController = FpsTimerController(widget.fps);
  }

  /// 判断是否需要重新初始化控制器
  bool _shouldReinitControllers(Tilt oldWidget) {
    return oldWidget.tiltStreamController != widget.tiltStreamController ||
        oldWidget.disable != widget.disable ||
        oldWidget.fps != widget.fps ||
        oldWidget.tiltConfig != widget.tiltConfig;
  }

  /// 调整尺寸及初始参数
  void _onResize(Size size) {
    final oldSize = Size(_width, _height);
    if (oldSize != size) {
      _isInit = true;
      _width = size.width;
      _height = size.height;
      setState(() {
        _currentPosition = Utils.progressPosition(
          _width,
          _height,
          _initAreaProgress,
        );
      });
    }
  }

  /// 处理手势 Stream 触发
  void _handleGesturesStream(TiltStreamModel? tiltStreamModel) {
    if (tiltStreamModel == null) return;
    if (tiltStreamModel.gesturesType == GesturesType.none) return;
    if (!_isInit || widget.disable) return;
    switch (tiltStreamModel.gesturesType) {
      case GesturesType.none:
        break;
      case GesturesType.touch || GesturesType.hover || GesturesType.controller:
        if (tiltStreamModel.gestureUse) {
          _onGesturesMove(
            tiltStreamModel.position,
            tiltStreamModel.gesturesType,
          );
        } else {
          _onGesturesRevert(
            tiltStreamModel.position,
            tiltStreamModel.gesturesType,
          );
        }
      case GesturesType.sensors:
        // Sensors 只会触发 onGestureMove，不会触发 onGestureLeave
        _currentPosition +=
            tiltStreamModel.position * widget.tiltConfig.sensorFactor;
        _onGesturesSensorsRevert();
        _currentPosition = Utils.constraintsPosition(
          _width,
          _height,
          _currentPosition,
        );
        _onGesturesMove(_currentPosition, tiltStreamModel.gesturesType);
    }
  }

  /// 手势移动触发
  ///
  /// [offset] 当前坐标
  void _onGesturesMove(Offset offset, GesturesType gesturesType) {
    if (!_isInit || widget.disable) return;
    if (!_fpsTimerController.shouldTrigger()) return;
    if (widget.tiltConfig.enableOutsideAreaMove ||
        Utils.isInRange(_width, _height, offset)) {
      _currentPosition = offset;
      _areaProgress = Utils.p2cAreaProgress(
        _width,
        _height,
        offset,
        widget.tiltConfig.direction,
      );
      _isMove = true;
      _currentGesturesType = gesturesType;
      _onGestureMove(_areaProgress, gesturesType);
    } else {
      _onGesturesRevert(offset, gesturesType);
    }
  }

  /// 手势复原触发
  ///
  /// [offset] 当前坐标
  void _onGesturesRevert(Offset offset, GesturesType gesturesType) {
    if (!_isInit || widget.disable || !_isMove) return;

    /// 是否还原的取值
    final position = widget.tiltConfig.enableRevert
        ? Utils.progressPosition(_width, _height, _initAreaProgress)
        : _currentPosition;
    _currentPosition = position;
    _areaProgress = Utils.p2cAreaProgress(
      _width,
      _height,
      position,
      widget.tiltConfig.direction,
    );
    _isMove = false;
    _currentGesturesType = gesturesType;
    _onGestureLeave(_areaProgress, gesturesType);
  }

  /// 手势传感器复原触发
  ///
  /// Sensors 只会触发 onGestureMove，不会触发 onGestureLeave
  void _onGesturesSensorsRevert() {
    if (!widget.tiltConfig.enableSensorRevert) return;

    /// 默认坐标
    final initPosition = Utils.progressPosition(
      _width,
      _height,
      _initAreaProgress,
    );

    /// 还原
    _currentPosition -= Offset(
          _currentPosition.dx - initPosition.dx,
          _currentPosition.dy - initPosition.dy,
        ) *
        widget.tiltConfig.sensorRevertFactor;
  }

  /// onGestureMove
  ///
  /// - [areaProgress] 当前坐标的区域进度
  void _onGestureMove(Offset areaProgress, GesturesType gesturesType) {
    if (widget.onGestureMove != null) {
      _triggerGestureCallback(
        widget.onGestureMove,
        areaProgress,
        gesturesType,
      );
    }
  }

  /// onGestureLeave
  ///
  /// - [areaProgress] 当前坐标的区域进度
  void _onGestureLeave(Offset areaProgress, GesturesType gesturesType) {
    if (widget.onGestureLeave != null) {
      _triggerGestureCallback(
        widget.onGestureLeave,
        areaProgress,
        gesturesType,
      );
    }
  }

  /// 触发手势回调
  void _triggerGestureCallback(
    TiltCallback? callback,
    Offset areaProgress,
    GesturesType gesturesType,
  ) {
    if (callback != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          callback(
            TiltData(
              isInit: _isInit,
              width: _width,
              height: _height,
              areaProgress: areaProgress,
              tiltConfig: widget.tiltConfig,
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
