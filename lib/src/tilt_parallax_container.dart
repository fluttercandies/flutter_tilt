import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/state/tilt_state.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';
import 'package:flutter_tilt/src/utils.dart';

/// 倾斜视差
@immutable
class TiltParallaxContainer extends StatelessWidget {
  /// 倾斜视差
  ///
  /// 用作视差的 Widget
  ///
  /// 只能在 [Tilt.childInner] 中使用
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
    final TiltConfig tiltConfig = tiltState.tiltConfig;

    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        end: tiltTweenAnimationEnd(isMove, tiltConfig, areaProgress),
      ),
      duration: isMove ? tiltConfig.moveDuration : tiltConfig.leaveDuration,
      curve: isMove ? tiltConfig.moveCurve : tiltConfig.leaveCurve,
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
