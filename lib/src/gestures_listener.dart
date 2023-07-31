import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/state/tilt_state.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';

/// 手势监听
class GesturesListener extends StatefulWidget {
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
  State<GesturesListener> createState() => _GesturesListenerState();
}

class _GesturesListenerState extends State<GesturesListener> {
  Widget get _child => widget.child;
  TiltConfig get _tiltConfig => widget.tiltConfig;

  late TiltState tiltState = TiltState.of(context)!;

  /// 避免 touch 和 hover 同时触发，导致 hover 离开的时候会“闪现”
  bool isTouch = false;

  @override
  Widget build(BuildContext context) {
    /// 不受滑动影响
    return GestureDetector(
      onVerticalDragUpdate: (_) {},
      onHorizontalDragUpdate: (_) {},

      /// 手势监听
      child: Listener(
        onPointerMove: (PointerMoveEvent e) {
          isTouch = true;
          tiltState.onMove(e.localPosition, GesturesType.touch);
        },
        onPointerUp: (PointerUpEvent e) {
          isTouch = false;
          tiltState.onRevert(e.localPosition, GesturesType.touch);
        },
        onPointerCancel: (PointerCancelEvent e) {
          isTouch = false;
          tiltState.onRevert(e.localPosition, GesturesType.touch);
        },
        child: MouseRegion(
          onHover: _tiltConfig.enableMouseHover && !isTouch
              ? (PointerHoverEvent e) =>
                  tiltState.onMove(e.localPosition, GesturesType.hover)
              : null,
          onExit: _tiltConfig.enableMouseHover && !isTouch
              ? (PointerExitEvent e) =>
                  tiltState.onRevert(e.localPosition, GesturesType.hover)
              : null,
          child: _child,
        ),
      ),
    );
  }
}
