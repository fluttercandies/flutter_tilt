import 'package:flutter/widgets.dart';

import 'widgets/tilt_mouse_listener.dart';
import 'widgets/tilt_touch_listener.dart';

import 'states/tilt_state.dart';

/// 手势监听
class GesturesListener extends StatefulWidget {
  /// 手势监听
  ///
  /// 对 Touch [TiltTouchListener] 和 Mouse [TiltMouseListener] 的监听触发
  const GesturesListener({super.key, required this.child});

  final Widget child;

  @override
  State<GesturesListener> createState() => _GesturesListenerState();
}

class _GesturesListenerState extends State<GesturesListener> {
  @override
  Widget build(BuildContext context) {
    print("GesturesListener Build");

    final TiltState tiltState = TiltState.of(context)!;

    return TiltTouchListener(
      onPointerMove: (event) {
        tiltState.onMove(event.localPosition);
      },
      onPointerUp: (event) {
        tiltState.onStop(event.localPosition);
      },
      onPointerCancel: (event) {
        tiltState.onStop(event.localPosition);
      },
      child: TiltMouseListener(
        onHover: (event) {
          tiltState.onMove(event.localPosition);
        },
        onExit: (event) {
          tiltState.onStop(event.localPosition);
        },
        child: widget.child,
      ),
    );
  }
}
