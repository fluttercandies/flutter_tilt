import 'dart:async' as async;

import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../enums.dart';
import '../../internal/controllers/fps_timer_controller.dart';
import '../../internal/controllers/tilt_gestures_controller.dart';
import '../../internal/mixin/tilt_tween_animation_mixin.dart';
import '../../internal/provider/tilt_animation_provider.dart';
import '../../internal/provider/tilt_provider.dart';
import '../../internal/tilt_data.dart';
import '../../models/tilt_stream_model.dart';
import '../../utils.dart';
import 'gestures_listener.dart';
import 'tilt_stream_builder.dart';

/// TiltWidget
/// 倾斜
class TiltWidget extends StatefulWidget {
  /// TiltWidget
  /// 倾斜
  ///
  /// {@template tilt.TiltWidget.desc.en}
  /// Core tilt widget with gesture handling, stream management, and animation.
  /// {@endtemplate}
  ///
  /// {@template tilt.TiltWidget.param.en}
  /// - [tiltStreamController] : `StreamController<TiltStreamModel>.broadcast()` to control the tilt.
  /// - [disable] : Disable all effects.
  /// - [fps] : Gesture triggered frames.
  /// - [tiltConfig] : Tilt effect config.
  /// - [onGestureMove] : Gesture move callback.
  /// - [onGestureLeave] : Gesture leave callback.
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltWidget.desc.zh}
  /// 核心倾斜 widget，包含手势处理、流管理和动画。
  /// {@endtemplate}
  ///
  /// {@template tilt.TiltWidget.param.zh}
  /// - [tiltStreamController]：通过 `StreamController<TiltStreamModel>.broadcast()` 来自定义控制倾斜。
  /// - [disable]：禁用所有效果。
  /// - [fps]：手势触发的帧数。
  /// - [tiltConfig]：倾斜效果配置。
  /// - [onGestureMove]：手势移动的回调触发。
  /// - [onGestureLeave]：手势离开的回调触发。
  /// {@endtemplate}
  ///
  const TiltWidget({
    super.key,
    required this.child,
    this.tiltStreamController,
    this.disable = false,
    this.fps = 120,
    this.tiltConfig = const TiltConfig(),
    this.onGestureMove,
    this.onGestureLeave,
  });

  final Widget child;

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

  /// Tilt effect config.
  ///
  /// ------
  ///
  /// 倾斜效果配置。
  final TiltConfig tiltConfig;

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
  State<TiltWidget> createState() => _TiltWidgetState();
}

class _TiltWidgetState extends State<TiltWidget> {
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
  void didUpdateWidget(TiltWidget oldWidget) {
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
            child: _TiltAnimationProviderWrapper(child: widget.child),
          );
        },
      ),
    );
  }

  /// 初始化控制器
  ///
  /// - [oldWidget] 旧 Wdiget 一般用于 [didUpdateWidget]
  void _initControllers({TiltWidget? oldWidget}) {
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
  bool _shouldReinitControllers(TiltWidget oldWidget) {
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
            ).toModel(),
            gesturesType,
          );
        }
      });
    }
  }
}

class _TiltAnimationProviderWrapper extends StatefulWidget {
  /// Provides a shared tween animation in a single Tilt tree to avoid duplicate Providers
  ///
  /// ------
  ///
  /// 在单个 Tilt 树内统一提供 tween 动画，避免多个子 widget 重复创建 Provider
  const _TiltAnimationProviderWrapper({required this.child});

  final Widget child;

  @override
  State<_TiltAnimationProviderWrapper> createState() =>
      _TiltAnimationProviderWrapperState();
}

class _TiltAnimationProviderWrapperState
    extends State<_TiltAnimationProviderWrapper>
    with TickerProviderStateMixin, TiltTweenAnimationMixin {
  @override
  Widget build(BuildContext context) {
    return TiltAnimationProvider(
      tiltTweenAnimation: tiltTweenAnimation,
      child: widget.child,
    );
  }
}
