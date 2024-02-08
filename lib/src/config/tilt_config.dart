import 'package:flutter/widgets.dart';

import '../enums.dart';
import '../data/tilt_data.dart';

/// 倾斜回调
typedef TiltCallback = void Function(
  TiltDataModel tiltDataModel,
  GesturesType gesturesType,
);

/// 倾斜配置
@immutable
class TiltConfig {
  /// 倾斜配置
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
  }) : assert(sensorRevertFactor >= 0 && sensorRevertFactor <= 1);

  /// 禁用
  final bool disable;

  /// 初始倾斜量
  ///
  /// {@template tilt.TiltConfig.initial}
  /// 最大倾斜角度依据 [angle]
  ///
  /// 正常范围 (x, y)：(1, 1) 至 (-1, -1)
  ///
  /// 你可以超过这个范围，但是手势移动过程中的最大倾斜量始终按照 [angle] 进行倾斜
  ///
  /// 例如：
  /// * (0, 0) 会保持平面
  /// * (1.0, 1.0) 会倾斜左上角 [angle] 最大角度
  /// * (-1.0, -1.0) 会倾斜右下角 [angle] 最大角度
  /// * (2, 2) 会倾斜左上角 [angle] 最大角度*2
  /// {@endtemplate}
  final Offset? initial;

  /// 可倾斜角度
  ///
  /// {@template tilt.TiltConfig.angle}
  /// 例如：
  /// * 0 会停止不动
  /// * 180 会翻转
  ///
  /// 调整该值后，一般还需要调整以下值，以保持一种相对正确的阴影关系
  /// * [ShadowConfig]
  /// {@endtemplate}
  final double angle;

  /// 倾斜方向
  ///
  /// 允许多个方向的值，默认所有方向
  ///
  /// 内置一些常用的方向，例如：[TiltDirection.top]
  ///
  /// 如果还需要一些特殊的方向，可以像这样自定义 [TiltDirection(0.1, 0.1)]
  final List<TiltDirection>? direction;

  /// 开启倾斜反向
  ///
  /// {@template tilt.TiltConfig.enableReverse}
  /// 切换触摸区域向上或向下倾斜
  ///
  /// 调整该值后，一般还需要调整以下值，以保持一种相对正确的关系效果
  /// * [LightConfig.enableReverse]
  /// * [ShadowConfig.enableReverse]
  /// {@endtemplate}
  final bool enableReverse;

  /// FilterQuality
  final FilterQuality? filterQuality;

  /// 开启传感器触发倾斜
  ///
  /// 设备陀螺仪传感器触发倾斜
  final bool enableGestureSensors;

  /// 传感器触发系数（灵敏度）
  final double sensorFactor;

  /// 开启传感器倾斜复原
  ///
  /// * true  倾斜后会按照 [sensorRevertFactor] 复原至初始状态
  /// * false 保留最后倾斜的状态
  final bool enableSensorRevert;

  /// 传感器复原系数（阻尼）
  ///
  /// 阻尼范围：0-1
  final double sensorRevertFactor;

  /// 传感器移动时的动画持续时间
  final Duration sensorMoveDuration;

  /// 开启手势 Hover 触发倾斜
  final bool enableGestureHover;

  /// 开启手势 Touch 触发倾斜
  final bool enableGestureTouch;

  /// 开启倾斜复原
  ///
  /// `仅对手势 Touch Hover 有效`
  ///
  /// * true  退出触发区域后会复原至初始状态
  /// * false 保留最后倾斜的状态
  final bool enableRevert;

  /// 开启倾斜过程中区域外可以继续移动
  ///
  /// `仅对手势 Touch 按下后的移动有效`
  /// [GesturesListener] 触发的 [Listener.onPointerMove]
  ///
  /// 当触发手势移动的倾斜过程中，
  /// 手势移动到区域外是否可以继续移动。
  ///
  /// * true: 手势触发过程中超出区域可以继续移动
  /// * flase: 超出区域后回到初始状态
  final bool enableOutsideAreaMove;

  /// 手势移动时的动画持续时间
  ///
  /// `仅对手势 Touch Hover 有效`
  final Duration moveDuration;

  /// 手势离开后的动画持续时间
  ///
  /// `仅对手势 Touch Hover 有效`
  final Duration leaveDuration;

  /// 手势移动时的动画曲线
  ///
  /// `仅对手势 Touch Hover 有效`
  final Curve moveCurve;

  /// 手势离开后的动画曲线
  ///
  /// `仅对手势 Touch Hover 有效`
  final Curve leaveCurve;

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
        other.leaveCurve == leaveCurve;
  }

  @override
  int get hashCode {
    return Object.hash(
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
    );
  }
}

/// child 其他布局
@immutable
class ChildLayout {
  /// child 其他布局
  const ChildLayout({
    this.outer = const <Widget>[],
    this.inner = const <Widget>[],
    this.behind = const <Widget>[],
  });

  /// 外部
  ///
  /// {@template tilt.ChildLayout.outer}
  /// 位于 [child] 外部，布局会超出 [child] 显示。
  ///
  /// 本身作为 [Stack]，可以搭配 [Stack] 相关布局，
  ///
  /// 一般用作视差的 Widget
  /// {@endtemplate}
  final List<Widget> outer;

  /// 内部
  ///
  /// {@template tilt.ChildLayout.inner}
  /// 位于 [child] 内部，布局不会超出 [child] 显示。
  ///
  /// 本身作为 [Stack]，可以搭配 [Stack] 相关布局，
  ///
  /// 一般用作视差的 Widget
  /// {@endtemplate}
  final List<Widget> inner;

  /// 后面
  ///
  /// {@template tilt.ChildLayout.behind}
  /// 位于 [child] 后面，布局会超出 [child] 显示。
  ///
  /// 本身作为 [Stack]，可以搭配 [Stack] 相关布局，
  ///
  /// 一般用作视差的 Widget
  /// {@endtemplate}
  final List<Widget> behind;
}

/// 倾斜方向
@immutable
class TiltDirection {
  /// 倾斜方向
  ///
  /// * 范围 (x, y)：(1, 1) 至 (-1, -1)
  /// * 中心 (x, y)：(0, 0)
  ///
  /// 例如：
  /// * (0, 0)    中心不倾斜
  /// * (1, 1)    最左上方
  /// * (0, 1)    最上方
  /// * (0, 0.9)  上方 0.9 比例的位置
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
      if (x > 0) {
        dx = dx > value.dx ? dx : value.dx;
      }
      if (y > 0) {
        dy = dy > value.dy ? dy : value.dy;
      }
      if (x < 0) {
        dx = dx < value.dx ? dx : value.dx;
      }
      if (y < 0) {
        dy = dy < value.dy ? dy : value.dy;
      }

      /// 符合项
      if (x > 0 && x <= value.dx) {
        dx = x;
      }
      if (y > 0 && y <= value.dy) {
        dy = y;
      }
      if (x < 0 && x >= value.dx) {
        dx = x;
      }
      if (y < 0 && y >= value.dy) {
        dy = y;
      }
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
