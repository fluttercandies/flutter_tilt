import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../enums.dart';

/// Tilt Base Provider
class TiltProvider extends InheritedWidget {
  /// Tilt Base Provider
  const TiltProvider({
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

  static TiltProvider of(BuildContext context) {
    final tiltProvider =
        context.dependOnInheritedWidgetOfExactType<TiltProvider>();
    assert(tiltProvider != null, 'No TiltProvider found in context');
    return tiltProvider!;
  }

  @override
  bool updateShouldNotify(TiltProvider oldWidget) =>
      isInit != oldWidget.isInit ||
      width != oldWidget.width ||
      height != oldWidget.height ||
      areaProgress != oldWidget.areaProgress ||
      isMove != oldWidget.isMove ||
      currentGesturesType != oldWidget.currentGesturesType ||
      tiltConfig != oldWidget.tiltConfig;
}
