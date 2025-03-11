import 'package:flutter/widgets.dart';

import '../config/tilt_config.dart';
import '../enums.dart';

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
    required this.isMove,
    required this.currentGesturesType,
    required this.tiltConfig,
    required this.onResize,
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

  /// 当前手势类型
  final GesturesType currentGesturesType;

  /// 倾斜配置
  final TiltConfig tiltConfig;

  /// 调整尺寸
  final void Function(Size) onResize;

  static TiltState of(BuildContext context) {
    final TiltState? tilt =
        context.dependOnInheritedWidgetOfExactType<TiltState>();
    assert(tilt != null, 'No TiltState found in context');
    return tilt!;
  }

  @override
  bool updateShouldNotify(TiltState oldWidget) =>
      isInit != oldWidget.isInit ||
      width != oldWidget.width ||
      height != oldWidget.height ||
      areaProgress != oldWidget.areaProgress ||
      isMove != oldWidget.isMove ||
      currentGesturesType != oldWidget.currentGesturesType ||
      tiltConfig != oldWidget.tiltConfig;
}
