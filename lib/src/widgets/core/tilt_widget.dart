import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../controllers/tilt_controller.dart';
import '../../enums.dart';
import '../../internal/action_input/tilt_action_input_coordinator.dart';
import '../../internal/mixin/tilt_tween_animation_mixin.dart';
import '../../internal/provider/tilt_animation_provider.dart';
import '../../internal/provider/tilt_provider.dart';
import '../../internal/tilt_state.dart';
import '../../models/tilt_stream_model.dart';
import '../../utils/fps_throttle.dart';
import '../../utils/utils.dart';
import 'gestures_listener.dart';
import 'widget_size_getter.dart';

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
  /// - [tiltController] : Controller for custom tilt input.
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
  /// - [tiltController]：用于自定义倾斜输入的控制器。
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
    this.tiltController,
    this.disable = false,
    this.fps = 120,
    this.tiltConfig = const TiltConfig(),
    this.onGestureMove,
    this.onGestureLeave,
  });

  final Widget child;

  /// Tilt Controller
  ///
  /// Controller for custom tilt input.
  ///
  /// ------
  ///
  /// 用于自定义倾斜输入的控制器。
  final TiltController? tiltController;

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
  late TiltState _tiltState;
  late FpsThrottle _fpsThrottle;
  late TiltActionInputCoordinator _tiltActionInputCoordinator;

  StreamSubscription<TiltStreamModel>? _tiltStreamSubscription;

  /// 默认 TiltController
  ///
  /// [widget.tiltController] 为 null 时使用
  final TiltController _kDefaultTiltController = TiltController();

  /// 当前坐标
  late Offset _currentPosition;

  /// 初始坐标区域进度
  Offset get _initAreaProgress => widget.tiltConfig.initial ?? Offset.zero;

  TiltController get _effectiveTiltController =>
      widget.tiltController ?? _kDefaultTiltController;

  @override
  void initState() {
    super.initState();
    _tiltState = TiltState(
      isInit: false,
      width: 0.0,
      height: 0.0,
      areaProgress: _initAreaProgress,
      isActive: false,
      currentGesturesType: GesturesType.none,
      tiltConfig: widget.tiltConfig,
    );
    _currentPosition = _tiltState.position;

    /// 初始化 FpsThrottle
    _fpsThrottle = FpsThrottle(widget.fps);

    _initCoordinator();
  }

  @override
  void dispose() {
    _tiltStreamSubscription?.cancel();
    _kDefaultTiltController.dispose();
    _fpsThrottle.dispose();
    _tiltActionInputCoordinator.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TiltWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.fps != widget.fps) {
      _fpsThrottle.dispose();
      _fpsThrottle = FpsThrottle(widget.fps);
    }

    if (_shouldReinit(oldWidget)) {
      _tiltState = _tiltState.copyWith(tiltConfig: widget.tiltConfig);
      _reinitCoordinator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GesturesListener(
      disable: widget.disable,
      tiltConfig: widget.tiltConfig,
      pointerInputSource: _tiltActionInputCoordinator.pointerInputSource,
      child: TiltProvider(
        data: _tiltState,
        child: _TiltAnimationProviderWrapper(
          child: WidgetSizeGetter(onSize: _onResize, child: widget.child),
        ),
      ),
    );
  }

  /// 初始化 [TiltActionInputCoordinator] 和输入源
  void _initCoordinator() {
    _tiltActionInputCoordinator = TiltActionInputCoordinator(
      tiltController: _effectiveTiltController,
      disable: widget.disable,
      fps: widget.fps,
      tiltConfig: widget.tiltConfig,
      initialPosition: _currentPosition,
    );
    _tiltActionInputCoordinator.init(context);
    _listenToTiltStream();
  }

  /// 重新初始化 Coordinator
  void _reinitCoordinator() {
    final oldCoordinator = _tiltActionInputCoordinator;

    /// 销毁旧的监听和协调器
    _tiltStreamSubscription?.cancel();
    oldCoordinator.dispose();

    /// 创建并初始化全新的协调器
    _initCoordinator();
  }

  /// 判断是否需要重新初始化
  bool _shouldReinit(TiltWidget oldWidget) {
    return oldWidget.tiltController != widget.tiltController ||
        oldWidget.disable != widget.disable ||
        oldWidget.fps != widget.fps ||
        oldWidget.tiltConfig != widget.tiltConfig;
  }

  /// 调整尺寸及初始参数
  void _onResize(Size size) {
    final oldSize = Size(_tiltState.width, _tiltState.height);
    if (oldSize != size) {
      setState(() {
        _tiltState = _tiltState.copyWith(
          isInit: true,
          width: size.width,
          height: size.height,
        );
        _currentPosition = Utils.progressPosition(
          _tiltState.width,
          _tiltState.height,
          _initAreaProgress,
        );
      });
    }
  }

  /// 监听 Tilt 输入流
  void _listenToTiltStream() {
    _tiltStreamSubscription?.cancel();
    _tiltStreamSubscription =
        _tiltActionInputCoordinator.stream?.listen((data) {
      _handleGesturesStream(data);
    });
  }

  /// 处理手势 Stream 触发
  void _handleGesturesStream(TiltStreamModel? tiltStreamModel) {
    if (tiltStreamModel == null) return;
    if (tiltStreamModel.gesturesType == GesturesType.none) return;
    if (!_tiltState.isInit || widget.disable) return;
    switch (tiltStreamModel.gesturesType) {
      case GesturesType.none:
        break;
      case GesturesType.touch || GesturesType.hover || GesturesType.controller:
        if (tiltStreamModel.isActive) {
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
          _tiltState.width,
          _tiltState.height,
          _currentPosition,
        );
        _onGesturesMove(_currentPosition, tiltStreamModel.gesturesType);
    }
  }

  /// 手势移动触发
  ///
  /// [offset] 当前坐标
  void _onGesturesMove(Offset offset, GesturesType gesturesType) {
    if (!_tiltState.isInit || widget.disable) return;
    if (!_fpsThrottle.shouldTrigger()) return;
    if (widget.tiltConfig.enableOutsideAreaMove ||
        Utils.isInRange(_tiltState.width, _tiltState.height, offset)) {
      setState(() {
        _currentPosition = offset;
        _tiltState = _tiltState.moveTo(offset, gesturesType);
      });

      _onGestureMove(_tiltState.areaProgress, gesturesType);
    } else {
      _onGesturesRevert(offset, gesturesType);
    }
  }

  /// 手势复原触发
  ///
  /// [offset] 当前坐标
  void _onGesturesRevert(Offset offset, GesturesType gesturesType) {
    if (!_tiltState.isInit || widget.disable || !_tiltState.isActive) return;

    /// 是否还原的取值
    final position = _tiltState.resolveRevertPosition(
      currentPosition: _currentPosition,
      initialAreaProgress: _initAreaProgress,
    );
    setState(() {
      _currentPosition = position;
      _tiltState = _tiltState.revertTo(position, gesturesType);
    });
    _onGestureLeave(_tiltState.areaProgress, gesturesType);
  }

  /// 手势传感器复原触发
  ///
  /// Sensors 只会触发 onGestureMove，不会触发 onGestureLeave
  void _onGesturesSensorsRevert() {
    if (!widget.tiltConfig.enableSensorRevert) return;

    /// 默认坐标
    final initPosition = Utils.progressPosition(
      _tiltState.width,
      _tiltState.height,
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
    if (callback != null && mounted) {
      callback(
        _tiltState
            .copyWith(
              areaProgress: areaProgress,
              currentGesturesType: gesturesType,
            )
            .toModel(),
        gesturesType,
      );
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
