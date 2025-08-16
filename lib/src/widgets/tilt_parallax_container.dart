import 'package:flutter/widgets.dart';

import '../internal/mixin/tilt_tween_animation_mixin.dart';
import '../internal/tilt_state.dart';

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
    final tiltState = TiltState.of(context);
    final animationEnd = tiltTweenAnimationEnd(
      tiltState.isMove,
      tiltState.tiltConfig,
      tiltState.areaProgress,
    );
    final animationDuration = tiltTweenAnimationDuration(
      tiltState.isMove,
      tiltState.currentGesturesType,
      tiltState.tiltConfig,
    );
    final animationCurve = tiltTweenAnimationCurve(
      tiltState.isMove,
      tiltState.currentGesturesType,
      tiltState.tiltConfig,
    );

    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(end: animationEnd),
      duration: animationDuration,
      curve: animationCurve,
      builder: (BuildContext context, Offset areaProgress, Widget? child) {
        return Transform(
          filterQuality: filterQuality,
          transform: tiltParallaxTransform(
            areaProgress,
            size,
            tiltState.tiltConfig.enableReverse,
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
    final dx = size.dx * areaProgress.dx;
    final dy = size.dy * areaProgress.dy;
    final offset = enableReverse ? Offset(-dx, -dy) : Offset(dx, dy);
    return Matrix4.identity()..translate(offset.dx, offset.dy);
  }
}
