import 'package:flutter/widgets.dart';

/// Tilt
class TiltState extends InheritedWidget {
  const TiltState({
    Key? key,
    required this.position,
    required this.isMove,
    required this.onMove,
    required this.onStop,
    required Widget child,
  }) : super(key: key, child: child);

  /// 坐标位置
  final Offset position;

  /// 是否正在移动
  final bool isMove;

  /// 坐标移动
  final void Function(Offset) onMove;

  /// 停止移动
  final void Function(Offset) onStop;

  static TiltState? of(BuildContext context) {
    final tilt = context.dependOnInheritedWidgetOfExactType<TiltState>();
    assert(tilt != null, 'No TiltState found in context');
    return tilt;
  }

  @override
  bool updateShouldNotify(TiltState oldWidget) {
    late bool update = false;
    if (position != oldWidget.position) update = true;
    if (isMove != oldWidget.isMove) update = true;
    return update;
  }
}
