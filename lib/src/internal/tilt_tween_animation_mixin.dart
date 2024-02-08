import 'package:flutter/widgets.dart';

import '../config/tilt_config.dart';
import '../enums.dart';

mixin TiltTweenAnimation {
  /// Tilt TweenAnimation End
  ///
  /// - [isMove] 是否移动
  /// - [tiltConfig] TiltConfig
  /// - [areaProgress] 当前进度
  ///
  /// @return [Offset] 倾斜反向进度
  Offset tiltTweenAnimationEnd(
    bool isMove,
    TiltConfig tiltConfig,
    Offset areaProgress,
  ) =>
      isMove || !tiltConfig.enableRevert
          ? areaProgress
          : (tiltConfig.initial ?? Offset.zero);

  /// Tilt TweenAnimation Duration
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
      GesturesType.sensors => tiltConfig.sensorMoveDuration,
    };
  }

  /// Tilt TweenAnimation Curve
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
      GesturesType.none => Curves.linear,
      GesturesType.touch ||
      GesturesType.hover =>
        isMove ? tiltConfig.moveCurve : tiltConfig.leaveCurve,
      GesturesType.sensors => Curves.linear,
    };
  }
}
