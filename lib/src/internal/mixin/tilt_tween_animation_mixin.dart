import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../enums.dart';
import '../tilt_state.dart';

mixin TiltTweenAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  /// TiltTween 动画控制器
  late AnimationController tiltTweenAnimationController;

  /// TiltTween 动画
  late Animation<Offset> tiltTweenAnimation;

  /// 从 Enter 过渡至 Move 的动画控制器
  late AnimationController enterToMoveAnimationController;

  /// 标记是否处于进入动画状态
  bool _isEnter = false;

  bool _didChangeDependencies = false;

  @override
  void initState() {
    super.initState();
    _initTiltTweenAnimation();
    _initEnterToMoveAnimation();
  }

  @override
  void dispose() {
    tiltTweenAnimationController.dispose();
    enterToMoveAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tiltState = TiltState.of(context);
    _updateTiltTweenAnimation(tiltState);
    _didChangeDependencies = true;
  }

  /// Tilt TweenAnimation End
  ///
  /// 倾斜动画目标位置
  ///
  /// - [isMove] 是否移动
  /// - [tiltConfig] TiltConfig
  /// - [areaProgress] 当前进度
  ///
  /// @return [Offset] 倾斜目标位置
  Offset tiltTweenAnimationEnd(
    bool isMove,
    TiltConfig tiltConfig,
    Offset areaProgress,
  ) {
    if (isMove || !tiltConfig.enableRevert) {
      return areaProgress;
    }
    return tiltConfig.initial ?? Offset.zero;
  }

  /// Tilt TweenAnimation Duration
  ///
  /// 倾斜动画的持续时间
  ///
  /// - [isMove] 是否移动
  /// - [currentGesturesType] 当前手势类型
  /// - [tiltConfig] TiltConfig
  ///
  /// @return [Duration]
  Duration tiltTweenAnimationDuration(
    bool isMove,
    GesturesType currentGesturesType,
    TiltConfig tiltConfig,
  ) {
    return switch (currentGesturesType) {
      GesturesType.none => Duration.zero,
      GesturesType.touch ||
      GesturesType.hover =>
        _dynamicAnimationDuration(isMove, currentGesturesType, tiltConfig),
      GesturesType.controller => isMove
          ? tiltConfig.controllerMoveDuration
          : tiltConfig.controllerLeaveDuration,
      GesturesType.sensors => tiltConfig.sensorMoveDuration,
    };
  }

  /// Tilt TweenAnimation Curve
  ///
  /// 倾斜动画的 Curve
  ///
  /// - [isMove] 是否移动
  /// - [currentGesturesType] 当前手势类型
  /// - [tiltConfig] TiltConfig
  ///
  /// @return [Curve]
  Curve tiltTweenAnimationCurve(
    bool isMove,
    GesturesType currentGesturesType,
    TiltConfig tiltConfig,
  ) {
    return switch (currentGesturesType) {
      GesturesType.none || GesturesType.controller => Curves.linear,
      GesturesType.touch ||
      GesturesType.hover =>
        _dynamicAnimationCurve(isMove, currentGesturesType, tiltConfig),
      GesturesType.sensors => Curves.linear,
    };
  }

  /// 初始化 TiltTween 动画相关
  void _initTiltTweenAnimation() {
    tiltTweenAnimationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    tiltTweenAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(tiltTweenAnimationController);
  }

  /// 初始化 EnterToMove 动画相关
  void _initEnterToMoveAnimation() {
    enterToMoveAnimationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    enterToMoveAnimationController.addListener(_updateEnterToMoveAnimation);
  }

  /// 更新 TiltTween 动画
  void _updateTiltTweenAnimation(TiltState tiltState) {
    final animationEnd = tiltTweenAnimationEnd(
      tiltState.isMove,
      tiltState.tiltConfig,
      tiltState.areaProgress,
    );

    /// 更新 enterToMoveAnimationController 的持续时间
    enterToMoveAnimationController.duration =
        tiltState.tiltConfig.enterToMoveDuration;

    if (tiltTweenAnimation.value == animationEnd) return;

    final animationDuration = tiltTweenAnimationDuration(
      tiltState.isMove,
      tiltState.currentGesturesType,
      tiltState.tiltConfig,
    );
    final animationCurve = tiltTweenAnimationCurve(
      tiltState.isMove,
      tiltState.currentGesturesType,
      tiltState.tiltConfig,
    );

    /// 更新 tiltTweenAnimationController 的持续时间
    tiltTweenAnimationController.duration = animationDuration;

    /// 创建 Tilt 的 Tween 并应用 Curve
    final tiltCurvedTween = Tween<Offset>(
      begin: tiltTweenAnimation.value,
      end: animationEnd,
    ).chain(CurveTween(curve: animationCurve));

    /// 创建 TiltTween 动画
    tiltTweenAnimation = tiltCurvedTween.animate(tiltTweenAnimationController);

    /// 启动 TiltTween 动画
    tiltTweenAnimationController.forward(from: 0.0);
  }

  /// 更新 EnterToMove 动画
  void _updateEnterToMoveAnimation() {
    if (!context.mounted) return;

    /// 避免 didChangeDependencies 和 build 的 updateTiltTweenAnimation 更新同步调用
    if (!_didChangeDependencies && enterToMoveAnimationController.isAnimating) {
      final tiltState = TiltState.of(context);
      _updateTiltTweenAnimation(tiltState);
      setState(() {});
    }
    _didChangeDependencies = false;
  }

  /// 是否有效的 EnterToMove 动画
  bool _isValidEnterToMove(TiltConfig tiltConfig) {
    if (tiltConfig.enterToMoveDuration == Duration.zero ||
        tiltConfig.enterDuration == tiltConfig.moveDuration) {
      return false;
    }
    return true;
  }

  /// 启动 EnterToMove 动画
  void _startEnterToMoveAnimation() {
    if (_isEnter) return;
    _isEnter = true;
    enterToMoveAnimationController.reset();
    enterToMoveAnimationController.forward();
  }

  /// 停止 EnterToMove 动画
  void _stopEnterToMoveAnimation() {
    if (!_isEnter) return;
    _isEnter = false;
    enterToMoveAnimationController.stop();
    enterToMoveAnimationController.reset();
  }

  /// 处理 EnterToMove 状态
  /// - [isMove] 是否移动
  /// - [currentGesturesType] 当前手势类型
  /// - [tiltConfig] TiltConfig
  void _handleEnterToMoveState(
    bool isMove,
    GesturesType currentGesturesType,
    TiltConfig tiltConfig,
  ) {
    if (!_isValidEnterToMove(tiltConfig)) return;

    final isValidGesturesType = [
      GesturesType.touch,
      GesturesType.hover,
    ].contains(currentGesturesType);

    if (isMove && isValidGesturesType) {
      _startEnterToMoveAnimation();
    } else {
      _stopEnterToMoveAnimation();
    }
  }

  /// 动态计算 Animation Duration
  Duration _dynamicAnimationDuration(
    bool isMove,
    GesturesType currentGesturesType,
    TiltConfig tiltConfig,
  ) {
    /// 处理 EnterToMove 状态
    _handleEnterToMoveState(isMove, currentGesturesType, tiltConfig);

    /// 离开
    if (!isMove) {
      return tiltConfig.leaveDuration;
    }

    /// 是否有效的 EnterToMove 动画
    if (!_isValidEnterToMove(tiltConfig)) {
      return tiltConfig.moveDuration;
    }

    /// 非 Enter 状态 || EnterToMove 动画已完成
    if (!_isEnter || enterToMoveAnimationController.isCompleted) {
      return tiltConfig.moveDuration;
    }

    /// Enter 状态，动态计算从 enter 过渡至 move 的 Duration
    final enterToMoveDuration = _enterToMoveDuration(tiltConfig);
    return enterToMoveDuration;
  }

  /// 动态计算从 Enter 过渡至 Move 的 Duration
  /// - [tiltConfig] TiltConfig
  Duration _enterToMoveDuration(TiltConfig tiltConfig) {
    var progress = enterToMoveAnimationController.value;

    if (progress >= 1) tiltConfig.moveDuration;

    progress = tiltConfig.enterToMoveCurve.transform(progress);
    final tween = Tween<Duration>(
      begin: tiltConfig.enterDuration,
      end: tiltConfig.moveDuration,
    );
    final duration = tween.transform(progress);

    final minDuration =
        tiltConfig.enterDuration.compareTo(tiltConfig.moveDuration) < 0
            ? tiltConfig.enterDuration
            : tiltConfig.moveDuration;
    final maxDuration =
        tiltConfig.enterDuration.compareTo(tiltConfig.moveDuration) > 0
            ? tiltConfig.enterDuration
            : tiltConfig.moveDuration;

    if (duration < minDuration) return minDuration;
    if (duration > maxDuration) return maxDuration;

    return duration;
  }

  /// 动态计算 Animation Curve
  Curve _dynamicAnimationCurve(
    bool isMove,
    GesturesType currentGesturesType,
    TiltConfig tiltConfig,
  ) {
    /// 离开
    if (!isMove) {
      return tiltConfig.leaveCurve;
    }
    return tiltConfig.moveCurve;
  }
}
