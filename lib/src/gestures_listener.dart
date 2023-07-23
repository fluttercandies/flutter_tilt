import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/state/tilt_state.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';

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
        onPointerMove: (PointerMoveEvent e) =>
            tiltState.onMove(e.localPosition),
        onPointerUp: (PointerUpEvent e) => tiltState.onRevert(e.localPosition),
        onPointerCancel: (PointerCancelEvent e) =>
            tiltState.onRevert(e.localPosition),
        child: MouseRegion(
          onHover: tiltConfig.enableMouseHover
              ? (PointerHoverEvent e) => tiltState.onMove(e.localPosition)
              : null,
          onExit: tiltConfig.enableMouseHover
              ? (PointerExitEvent e) => tiltState.onRevert(e.localPosition)
              : null,
          child: child,
        ),
      ),
    );
  }
}
