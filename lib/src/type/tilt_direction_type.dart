import 'package:flutter/widgets.dart';

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
      : assert(_dx <= 1 && _dx >= -1),
        assert(_dy <= 1 && _dy >= -1);

  final double _dx;
  final double _dy;

  double get dx => _dx;
  double get dy => _dy;

  static TiltDirection none = const TiltDirection(0, 0);
  static TiltDirection top = const TiltDirection(0, 1);
  static TiltDirection bottom = const TiltDirection(0, -1);
  static TiltDirection left = const TiltDirection(1, 0);
  static TiltDirection right = const TiltDirection(-1, 0);
  static TiltDirection topLeft = top + left;
  static TiltDirection topRight = top + right;
  static TiltDirection bottomLeft = bottom + left;
  static TiltDirection bottomRight = bottom + right;
  static TiltDirection topBottom = top + bottom;
  static TiltDirection leftRight = left + right;

  /// 验证合法的方向并返回方向数据
  ///
  /// * [tiltDirection] 需要验证的方向坐标
  /// * [validator] 验证的方向范围
  static TiltDirection validator(
    TiltDirection tiltDirection,
    List<TiltDirection> validator,
  ) {
    final double x = tiltDirection.dx, y = tiltDirection.dy;
    late double dx = 0, dy = 0;

    for (TiltDirection value in validator) {
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
  String toString() =>
      'TiltDirection(${dx.toStringAsFixed(1)}, ${dy.toStringAsFixed(1)})';
}
