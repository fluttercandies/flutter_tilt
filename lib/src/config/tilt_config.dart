import 'package:flutter/widgets.dart';

import '../data/tilt_data.dart';
import '../enums.dart';

/// TiltCallback
/// 倾斜回调
typedef TiltCallback = void Function(
  TiltDataModel tiltDataModel,
  GesturesType gesturesType,
);

/// Tilt effect config.
/// 倾斜效果配置。
@immutable
class TiltConfig {
  /// Tilt effect config.
  /// 倾斜效果配置。
  const TiltConfig({
    this.disable = false,
    this.initial,
    this.angle = 10.0,
    this.direction,
    this.enableReverse = false,
    this.filterQuality,
    this.enableGestureSensors = true,
    this.sensorFactor = 10.0,
    this.enableSensorRevert = true,
    this.sensorRevertFactor = 0.05,
    this.sensorMoveDuration = const Duration(milliseconds: 50),
    this.enableGestureHover = true,
    this.enableGestureTouch = true,
    this.enableRevert = true,
    this.enableOutsideAreaMove = true,
    this.moveDuration = const Duration(milliseconds: 100),
    this.leaveDuration = const Duration(milliseconds: 300),
    this.moveCurve = Curves.linear,
    this.leaveCurve = Curves.linear,
    this.controllerMoveDuration = const Duration(milliseconds: 100),
    this.controllerLeaveDuration = const Duration(milliseconds: 300),
  }) : assert(sensorRevertFactor >= 0 && sensorRevertFactor <= 1);

  /// Only disable the tilt effect.
  ///
  /// ------
  ///
  /// 仅禁用倾斜效果。
  ///
  final bool disable;

  /// {@template tilt.TiltConfig.initial}
  ///
  /// Initial tilt progress,
  ///
  /// range (x, y): (1, 1) to (-1, -1),
  ///
  /// you can exceed the range,
  /// but the maximum tilt angle during gesture movement is always tilted according to [TiltConfig.angle].
  ///
  /// e.g.
  /// - (0.0, 0.0) center.
  /// - (1.0, 1.0) Maximum tilt top left [TiltConfig.angle].
  ///
  /// ------
  ///
  /// 倾斜进度的初始值，
  ///
  /// 范围 (x, y)：(1, 1) 至 (-1, -1)，
  ///
  /// 你可以超过这个范围，
  /// 但是手势移动过程中的最大倾斜角度始终按照 [TiltConfig.angle] 进行倾斜。
  ///
  /// 例如：
  /// - (0, 0) 中心，会保持平面。
  /// - (1.0, 1.0) 会倾斜左上角 [TiltConfig.angle] 最大角度。
  /// - (-1.0, -1.0) 会倾斜右下角 [TiltConfig.angle] 最大角度。
  /// - (2, 2) 会倾斜左上角 [TiltConfig.angle] 最大角度*2。
  ///
  /// {@endtemplate}
  final Offset? initial;

  /// {@template tilt.TiltConfig.angle}
  ///
  /// Maximum tilt angle.
  ///
  /// e.g.
  /// - 180 will flip.
  ///
  /// ------
  ///
  /// 最大倾斜角度。
  ///
  /// 例如：
  /// - 0 会停止不动。
  /// - 180 会翻转。
  ///
  /// {@endtemplate}
  ///
  final double angle;

  /// Tilt Direction,
  ///
  /// multiple directions,
  ///
  /// customized direction values.
  ///
  /// ------
  ///
  /// 倾斜方向
  ///
  /// 允许多个方向的值，默认所有方向
  ///
  /// 内置一些常用的方向，例如：[TiltDirection.top]
  ///
  /// 如果还需要一些特殊的方向，可以像这样自定义 [TiltDirection(0.1, 0.1)]
  ///
  final List<TiltDirection>? direction;

  /// {@template tilt.TiltConfig.enableReverse}
  ///
  /// Tilt reverse, can be tilted up or down.
  ///
  /// ------
  ///
  /// 倾斜反向，可以向上或向下倾斜。
  ///
  /// {@endtemplate}
  ///
  final bool enableReverse;

  /// FilterQuality
  final FilterQuality? filterQuality;

  /// Gyroscope sensor triggered tilt.
  ///
  /// Only the following gestures:
  /// [GesturesType.sensors]
  ///
  /// ------
  ///
  /// 陀螺仪传感器触发倾斜。
  ///
  /// 仅以下手势生效：
  /// [GesturesType.sensors]
  ///
  final bool enableGestureSensors;

  /// Sensor trigger factor (sensitivity).
  ///
  /// Only the following gestures:
  /// [GesturesType.sensors]
  ///
  /// ------
  ///
  /// 传感器触发系数（灵敏度）。
  ///
  /// 仅以下手势生效：
  /// [GesturesType.sensors]
  ///
  final double sensorFactor;

  /// Enable sensor tilt revert,
  /// will revert to the initial state.
  ///
  /// Only the following gestures:
  /// [GesturesType.sensors]
  ///
  /// ------
  ///
  /// 启用传感器倾斜复原，
  /// 会复原至初始状态。
  ///
  /// 仅以下手势生效：
  /// [GesturesType.sensors]
  ///
  final bool enableSensorRevert;

  /// Sensor revert factor (damping),
  ///
  /// range of values: 0-1.
  ///
  /// Only the following gestures:
  /// [GesturesType.sensors]
  ///
  /// ------
  ///
  /// 传感器复原系数（阻尼），
  ///
  /// 数值范围：0-1。
  ///
  /// 仅以下手势生效：
  /// [GesturesType.sensors]
  ///
  final double sensorRevertFactor;

  /// Animation duration during sensor move.
  ///
  /// Only the following gestures:
  /// [GesturesType.sensors]
  ///
  /// ------
  ///
  /// 传感器移动时的动画持续时间。
  ///
  /// 仅以下手势生效：
  /// [GesturesType.sensors]
  ///
  final Duration sensorMoveDuration;

  /// Hover gesture triggered tilt.
  ///
  /// Only the following gestures:
  /// [GesturesType.hover]
  ///
  /// ------
  ///
  /// 开启 Hover 手势触发倾斜。
  ///
  /// 仅以下手势生效：
  /// [GesturesType.hover]
  ///
  final bool enableGestureHover;

  /// Touch gesture triggered tilt.
  ///
  /// Only the following gestures:
  /// [GesturesType.touch]
  ///
  /// ------
  ///
  /// 开启 Touch 手势触发倾斜。
  ///
  /// 仅以下手势生效：
  /// [GesturesType.touch]
  ///
  final bool enableGestureTouch;

  /// Enable tilt revert,
  /// will revert to the initial state.
  ///
  /// Only the following gestures:
  /// [GesturesType.touch]
  /// [GesturesType.hover]
  /// [GesturesType.controller]
  ///
  /// ------
  ///
  /// 启用倾斜复原，
  /// 会复原至初始状态。
  ///
  /// 仅以下手势生效：
  /// [GesturesType.touch]
  /// [GesturesType.hover]
  /// [GesturesType.controller]
  ///
  final bool enableRevert;

  /// Tilt can continue to be triggered outside the area.
  ///
  /// Only the following gestures:
  /// [GesturesType.touch]
  /// [GesturesType.controller]
  ///
  /// ------
  ///
  /// 开启倾斜过程中区域外可以继续移动
  ///
  /// 仅以下手势生效：
  /// [GesturesType.touch]
  /// [GesturesType.controller]
  ///
  /// 当触发手势移动的倾斜过程中，
  /// 手势移动到区域外是否可以继续移动。
  ///
  final bool enableOutsideAreaMove;

  /// Animation duration during gesture move.
  ///
  /// Only the following gestures:
  /// [GesturesType.touch]
  /// [GesturesType.hover]
  ///
  /// ------
  ///
  /// 手势移动时的动画持续时间
  ///
  /// 仅以下手势生效：
  /// [GesturesType.touch]
  /// [GesturesType.hover]
  ///
  final Duration moveDuration;

  /// Animation duration after gesture leave.
  ///
  /// Only the following gestures:
  /// [GesturesType.touch]
  /// [GesturesType.hover]
  ///
  /// ------
  ///
  /// 手势离开后的动画持续时间
  ///
  /// 仅以下手势生效：
  /// [GesturesType.touch]
  /// [GesturesType.hover]
  ///
  final Duration leaveDuration;

  /// Animation curve during gesture move.
  ///
  /// Only the following gestures:
  /// [GesturesType.touch]
  /// [GesturesType.hover]
  ///
  /// ------
  ///
  /// 手势移动时的动画曲线
  ///
  /// 仅以下手势生效：
  /// [GesturesType.touch]
  /// [GesturesType.hover]
  ///
  final Curve moveCurve;

  /// Animation curve after gesture leave.
  ///
  /// Only the following gestures:
  /// [GesturesType.touch]
  /// [GesturesType.hover]
  ///
  /// ------
  ///
  /// 手势离开后的动画曲线
  ///
  /// 仅以下手势生效：
  /// [GesturesType.touch]
  /// [GesturesType.hover]
  ///
  final Curve leaveCurve;

  /// Animation duration during controller gesture move.
  ///
  /// Only the following gestures:
  /// [GesturesType.controller]
  ///
  /// ------
  ///
  /// [GesturesType.controller] 移动时的动画持续时间
  ///
  /// 仅以下手势生效：
  /// [GesturesType.controller]
  ///
  final Duration controllerMoveDuration;

  /// Animation duration after controller gesture leave.
  ///
  /// Only the following gestures:
  /// [GesturesType.controller]
  ///
  /// ------
  ///
  /// [GesturesType.controller] 离开后的动画持续时间
  ///
  /// 仅以下手势生效：
  /// [GesturesType.controller]
  final Duration controllerLeaveDuration;

  TiltConfig copyWith({
    bool? disable,
    Offset? initial,
    double? angle,
    List<TiltDirection>? direction,
    bool? enableReverse,
    FilterQuality? filterQuality,
    bool? enableGestureSensors,
    double? sensorFactor,
    bool? enableSensorRevert,
    double? sensorRevertFactor,
    Duration? sensorMoveDuration,
    bool? enableGestureHover,
    bool? enableGestureTouch,
    bool? enableRevert,
    bool? enableOutsideAreaMove,
    Duration? moveDuration,
    Duration? leaveDuration,
    Curve? moveCurve,
    Curve? leaveCurve,
    Duration? controllerMoveDuration,
    Duration? controllerLeaveDuration,
  }) {
    return TiltConfig(
      disable: disable ?? this.disable,
      initial: initial ?? this.initial,
      angle: angle ?? this.angle,
      direction: direction ?? this.direction,
      enableReverse: enableReverse ?? this.enableReverse,
      filterQuality: filterQuality ?? this.filterQuality,
      enableGestureSensors: enableGestureSensors ?? this.enableGestureSensors,
      sensorFactor: sensorFactor ?? this.sensorFactor,
      enableSensorRevert: enableSensorRevert ?? this.enableSensorRevert,
      sensorRevertFactor: sensorRevertFactor ?? this.sensorRevertFactor,
      sensorMoveDuration: sensorMoveDuration ?? this.sensorMoveDuration,
      enableGestureHover: enableGestureHover ?? this.enableGestureHover,
      enableGestureTouch: enableGestureTouch ?? this.enableGestureTouch,
      enableRevert: enableRevert ?? this.enableRevert,
      enableOutsideAreaMove:
          enableOutsideAreaMove ?? this.enableOutsideAreaMove,
      moveDuration: moveDuration ?? this.moveDuration,
      leaveDuration: leaveDuration ?? this.leaveDuration,
      moveCurve: moveCurve ?? this.moveCurve,
      leaveCurve: leaveCurve ?? this.leaveCurve,
      controllerMoveDuration:
          controllerMoveDuration ?? this.controllerMoveDuration,
      controllerLeaveDuration:
          controllerLeaveDuration ?? this.controllerLeaveDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TiltConfig &&
        other.disable == disable &&
        other.initial == initial &&
        other.angle == angle &&
        Object.hashAll(other.direction ?? []) ==
            Object.hashAll(direction ?? []) &&
        other.enableReverse == enableReverse &&
        other.filterQuality == filterQuality &&
        other.enableGestureSensors == enableGestureSensors &&
        other.sensorFactor == sensorFactor &&
        other.enableSensorRevert == enableSensorRevert &&
        other.sensorRevertFactor == sensorRevertFactor &&
        other.sensorMoveDuration == sensorMoveDuration &&
        other.enableGestureHover == enableGestureHover &&
        other.enableGestureTouch == enableGestureTouch &&
        other.enableRevert == enableRevert &&
        other.enableOutsideAreaMove == enableOutsideAreaMove &&
        other.moveDuration == moveDuration &&
        other.leaveDuration == leaveDuration &&
        other.moveCurve == moveCurve &&
        other.leaveCurve == leaveCurve &&
        other.controllerMoveDuration == controllerMoveDuration &&
        other.controllerLeaveDuration == controllerLeaveDuration;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      disable,
      initial,
      angle,
      Object.hashAll(direction ?? []),
      enableReverse,
      filterQuality,
      enableGestureSensors,
      sensorFactor,
      enableSensorRevert,
      sensorRevertFactor,
      sensorMoveDuration,
      enableGestureHover,
      enableGestureTouch,
      enableRevert,
      enableOutsideAreaMove,
      moveDuration,
      leaveDuration,
      moveCurve,
      leaveCurve,
      controllerMoveDuration,
      controllerLeaveDuration,
    ]);
  }
}

/// Other child layouts.
///
/// e.g. [TiltParallax] parallax inner, outer, behind.
///
/// ------
///
/// 其他 child 布局。
///
/// 例如：位于 child 内部、外部、后面的视差布局 [TiltParallax]。
///
@immutable
class ChildLayout {
  /// Other child layouts.
  ///
  /// e.g. [TiltParallax] parallax inner, outer, behind.
  ///
  /// ------
  ///
  /// 其他 child 布局。
  ///
  /// 例如：位于 child 内部、外部、后面的视差布局 [TiltParallax]。
  ///
  const ChildLayout({
    this.outer = const <Widget>[],
    this.inner = const <Widget>[],
    this.behind = const <Widget>[],
  });

  /// outer
  /// 外部
  ///
  /// {@template tilt.ChildLayout.outer}
  ///
  /// As with Stack,
  /// you can use the Stack layout to create widgets that are outer of the child.
  /// e.g. parallax effects.
  ///
  /// ------
  ///
  /// 与 Stack 一样，
  /// 你可以使用 Stack 布局来创建一些位于 `child 外部` 的 widget。
  /// 例如：视差效果。
  ///
  /// {@endtemplate}
  ///
  final List<Widget> outer;

  /// inner
  /// 内部
  ///
  /// {@template tilt.ChildLayout.inner}
  ///
  /// As with Stack,
  /// you can use the Stack layout to create widgets that are inner of the child.
  /// e.g. parallax effects.
  ///
  /// ------
  ///
  /// 与 Stack 一样，
  /// 你可以使用 Stack 布局来创建一些位于 `child 内部` 的 widget。
  /// 例如：视差效果。
  ///
  /// {@endtemplate}
  ///
  final List<Widget> inner;

  /// behind
  /// 后面
  ///
  /// {@template tilt.ChildLayout.behind}
  ///
  /// As with Stack,
  /// you can use the Stack layout to create widgets that are behind of the child.
  /// e.g. parallax effects.
  ///
  /// ------
  ///
  /// 与 Stack 一样，
  /// 你可以使用 Stack 布局来创建一些位于 `child 后面` 的 widget。
  /// 例如：视差效果。
  ///
  /// {@endtemplate}
  ///
  final List<Widget> behind;
}

/// Tilt Direction
/// 倾斜方向
@immutable
class TiltDirection {
  /// Tilt Direction
  /// 倾斜方向
  ///
  /// - 范围 (x, y)：(1, 1) 至 (-1, -1)
  /// - 中心 (x, y)：(0, 0)
  ///
  /// 例如：
  /// - (0, 0)    中心不倾斜
  /// - (1, 1)    最左上方
  /// - (0, 1)    最上方
  /// - (0, 0.9)  上方 0.9 比例的位置
  const TiltDirection(this._dx, this._dy)
      : assert(_dx <= 1.0 && _dx >= -1.0),
        assert(_dy <= 1.0 && _dy >= -1.0);

  final double _dx;
  final double _dy;

  double get dx => _dx;
  double get dy => _dy;

  static TiltDirection none = const TiltDirection(0.0, 0.0);
  static TiltDirection top = const TiltDirection(0.0, 1.0);
  static TiltDirection bottom = const TiltDirection(0.0, -1.0);
  static TiltDirection left = const TiltDirection(1.0, 0.0);
  static TiltDirection right = const TiltDirection(-1.0, 0.0);
  static TiltDirection topLeft = top + left;
  static TiltDirection topRight = top + right;
  static TiltDirection bottomLeft = bottom + left;
  static TiltDirection bottomRight = bottom + right;

  /// 验证合法的方向并返回方向数据
  ///
  /// - [tiltDirection] 需要验证的方向坐标
  /// - [validator] 验证的方向范围
  ///
  /// @return [TiltDirection]
  static TiltDirection validator(
    TiltDirection tiltDirection,
    List<TiltDirection> validator,
  ) {
    final double x = tiltDirection.dx, y = tiltDirection.dy;
    double dx = 0.0, dy = 0.0;

    for (final TiltDirection value in validator) {
      /// 默认最大设置的验证范围，避免方向值超出验证值的时候会返回 0
      if (x > 0) dx = dx > value.dx ? dx : value.dx;
      if (y > 0) dy = dy > value.dy ? dy : value.dy;
      if (x < 0) dx = dx < value.dx ? dx : value.dx;
      if (y < 0) dy = dy < value.dy ? dy : value.dy;

      /// 符合项
      if (x > 0 && x <= value.dx) dx = x;
      if (y > 0 && y <= value.dy) dy = y;
      if (x < 0 && x >= value.dx) dx = x;
      if (y < 0 && y >= value.dy) dy = y;
    }
    return TiltDirection(dx, dy);
  }

  TiltDirection operator +(TiltDirection other) =>
      TiltDirection(dx + other.dx, dy + other.dy);

  TiltDirection operator -() => TiltDirection(-dx, -dy);

  TiltDirection operator -(TiltDirection other) =>
      TiltDirection(dx - other.dx, dy - other.dy);

  TiltDirection operator *(double operand) =>
      TiltDirection(dx * operand, dy * operand);

  TiltDirection operator /(double operand) =>
      TiltDirection(dx / operand, dy / operand);

  TiltDirection operator ~/(double operand) =>
      TiltDirection((dx ~/ operand).toDouble(), (dy ~/ operand).toDouble());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TiltDirection && other.dx == dx && other.dy == dy;
  }

  @override
  int get hashCode => Object.hash(dx, dy);

  @override
  String toString() =>
      'TiltDirection(${dx.toStringAsFixed(1)}, ${dy.toStringAsFixed(1)})';
}
