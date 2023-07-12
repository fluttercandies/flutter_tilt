import 'package:flutter/widgets.dart';

/// Tilt
class TiltState extends InheritedWidget {
  const TiltState({
    Key? key,
    required this.isInit,
    required this.width,
    required this.height,
    required this.position,
    required this.areaProgress,
    required this.onResize,
    required this.isMove,
    required this.onMove,
    required this.onStop,
    required Widget child,
  }) : super(key: key, child: child);

  /// 是否初始化
  final bool isInit;

  /// 尺寸 width
  final double width;

  /// 尺寸 height
  final double height;

  /// 当前坐标位置
  final Offset position;

  /// 当前坐标的区域进度
  final Offset areaProgress;

  /// 是否正在移动
  final bool isMove;

  /// 调整尺寸
  final void Function(Size) onResize;

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
    if (isInit != oldWidget.isInit) update = true;
    if (width != oldWidget.width) update = true;
    if (height != oldWidget.height) update = true;
    if (position != oldWidget.position) update = true;
    if (areaProgress != oldWidget.areaProgress) update = true;
    if (isMove != oldWidget.isMove) update = true;
    return update;
  }
}
