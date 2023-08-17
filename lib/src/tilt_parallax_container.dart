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
          transform: Matrix4.identity()
            ..translate(value.dx * size.dx, value.dy * size.dy),
          child: child,
        );
      },
      child: child,
    );
  }
}
