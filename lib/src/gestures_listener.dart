import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/type/tilt_type.dart';

import 'package:flutter_tilt/src/state/tilt_state.dart';

/// 手势监听
class GesturesListener extends StatelessWidget {
  /// 手势监听
  ///
  /// 对 Touch [Listener] 和 Mouse [MouseRegion] 的监听触发
  const GesturesListener({
    super.key,
    required this.child,
    required this.tiltConfig,
  });

  final Widget child;
  final TiltConfig tiltConfig;

  @override
  Widget build(BuildContext context) {
    final TiltState tiltState = TiltState.of(context)!;

    /// 不受滑动影响
    return GestureDetector(
      onVerticalDragUpdate: (_) {},
      onHorizontalDragUpdate: (_) {},

      /// 手势监听
      child: Listener(
        onPointerMove: (e) => tiltState.onMove(e.localPosition),
        onPointerUp: (e) => tiltState.onStop(e.localPosition),
        onPointerCancel: (e) => tiltState.onStop(e.localPosition),
        child: MouseRegion(
          onHover: tiltConfig.enableMouseHover
              ? (e) => tiltState.onMove(e.localPosition)
              : null,
          onExit: (e) => tiltState.onStop(e.localPosition),
          child: child,
        ),
      ),
    );
  }
}
