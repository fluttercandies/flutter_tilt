import 'package:flutter/widgets.dart';

import '../enums.dart';
import '../state/tilt_state.dart';
import '../config/tilt_config.dart';
import '../internal/tilt_tween_animation_mixin.dart';

/// 倾斜视差
@immutable
class TiltParallaxContainer extends StatelessWidget with TiltTweenAnimation {
  /// 倾斜视差
  ///
  /// 用作视差的 Widget
  ///
  /// 只能在 [Tilt.childLayout] 中使用
  const TiltParallaxContainer({
    super.key,
    required this.child,
    required this.size,
    this.filterQuality,
  });

  final Widget child;

  /// 视差大小 (x, y)
  final Offset size;

  final FilterQuality? filterQuality;

  @override
  Widget build(BuildContext context) {
    final TiltState tiltState = TiltState.of(context)!;
    final Offset areaProgress = tiltState.areaProgress;
    final bool isMove = tiltState.isMove;
    final GesturesType currentGesturesType = tiltState.currentGesturesType;
    final TiltConfig tiltConfig = tiltState.tiltConfig;

    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        end: tiltTweenAnimationEnd(isMove, tiltConfig, areaProgress),
      ),
      duration:
          tiltTweenAnimationDuration(isMove, currentGesturesType, tiltConfig),
      curve: tiltTweenAnimationCurve(isMove, currentGesturesType, tiltConfig),
      builder: (BuildContext context, Offset value, Widget? child) {
        return Transform(
          filterQuality: filterQuality,
          transform: tiltParallaxTransform(
            value,
            size,
            tiltConfig.enableReverse,
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  /// 计算当前倾斜视差
  ///
  /// - [areaProgress] 当前坐标的区域进度
  /// - [size] 视差大小
  /// - [enableReverse] 开启倾斜反向，向上或向下倾斜
  Matrix4 tiltParallaxTransform(
    Offset areaProgress,
    Offset size,
    bool enableReverse,
  ) {
    final Offset offset = enableReverse
        ? Offset(-size.dx * areaProgress.dx, -size.dy * areaProgress.dy)
        : Offset(size.dx * areaProgress.dx, size.dy * areaProgress.dy);
    return Matrix4.identity()..translate(offset.dx, offset.dy);
  }
}
