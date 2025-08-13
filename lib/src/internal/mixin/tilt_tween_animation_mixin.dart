import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../enums.dart';

mixin TiltTweenAnimation {
  /// Tilt TweenAnimation End
  ///
  /// 倾斜动画结束的目标位置
  ///
  /// - [isMove] 是否移动
  /// - [tiltConfig] TiltConfig
  /// - [areaProgress] 当前进度
  ///
  /// @return [Offset] 倾斜结束的目标位置
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
        isMove ? tiltConfig.moveDuration : tiltConfig.leaveDuration,
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
        isMove ? tiltConfig.moveCurve : tiltConfig.leaveCurve,
      GesturesType.sensors => Curves.linear,
    };
  }
}
