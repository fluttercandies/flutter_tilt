import 'package:flutter/widgets.dart';

import '../config/tilt_config.dart';
import '../enums.dart';

mixin TiltTweenAnimation {
  /// Tilt TweenAnimation End
  ///
  /// - [isMove] 是否移动
  /// - [tiltConfig] TiltConfig
  /// - [areaProgress] 当前进度
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
  Duration tiltTweenAnimationDuration(
    bool isMove,
    GesturesType currentGesturesType,
    TiltConfig tiltConfig,
  ) {
    late Duration duration;
    switch (currentGesturesType) {
      case GesturesType.none:
        duration = Duration.zero;
        break;
      case GesturesType.touch:
        duration = isMove ? tiltConfig.moveDuration : tiltConfig.leaveDuration;
        break;
      case GesturesType.hover:
        duration = isMove ? tiltConfig.moveDuration : tiltConfig.leaveDuration;
        break;
      case GesturesType.sensors:
        duration = tiltConfig.sensorMoveDuration;
        break;
    }
    return duration;
  }

  /// Tilt TweenAnimation Curve
  ///
  /// - [isMove] 是否移动
  /// - [currentGesturesType] 当前手势类型
  /// - [tiltConfig] TiltConfig
  Curve tiltTweenAnimationCurve(
    bool isMove,
    GesturesType currentGesturesType,
    TiltConfig tiltConfig,
  ) {
    late Curve curve;
    switch (currentGesturesType) {
      case GesturesType.none:
        curve = Curves.linear;
        break;
      case GesturesType.touch:
        curve = isMove ? tiltConfig.moveCurve : tiltConfig.leaveCurve;
        break;
      case GesturesType.hover:
        curve = isMove ? tiltConfig.moveCurve : tiltConfig.leaveCurve;
        break;
      case GesturesType.sensors:
        curve = Curves.linear;
        break;
    }
    return curve;
  }
}
