import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/enums.dart';

/// Tilt State
class TiltState extends InheritedWidget {
  /// Tilt State
  const TiltState({
    super.key,
    required super.child,
    required this.isInit,
    required this.width,
    required this.height,
    required this.areaProgress,
    required this.onResize,
    required this.isMove,
    required this.onMove,
    required this.onRevert,
  });

  /// 是否初始化
  final bool isInit;

  /// 尺寸 width
  final double width;

  /// 尺寸 height
  final double height;

  /// 当前坐标的区域进度
  final Offset areaProgress;

  /// 是否正在移动
  final bool isMove;

  /// 调整尺寸
  final void Function(Size) onResize;

  /// 坐标移动
  final void Function(Offset, GesturesType) onMove;

  /// 坐标复原
  final void Function(Offset, GesturesType) onRevert;

  static TiltState? of(BuildContext context) {
    final TiltState? tilt =
        context.dependOnInheritedWidgetOfExactType<TiltState>();
    assert(tilt != null, 'No TiltState found in context');
    return tilt;
  }

  @override
  bool updateShouldNotify(TiltState oldWidget) {
    late bool update = false;
    if (isInit != oldWidget.isInit) {
      update = true;
    }
    if (width != oldWidget.width) {
      update = true;
    }
    if (height != oldWidget.height) {
      update = true;
    }
    if (areaProgress != oldWidget.areaProgress) {
      update = true;
    }
    if (isMove != oldWidget.isMove) {
      update = true;
    }
    return update;
  }
}
