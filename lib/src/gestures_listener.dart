import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/compatible/tilt_mouse_listener.dart';
import 'package:flutter_tilt/src/compatible/tilt_touch_listener.dart';

import 'package:flutter_tilt/src/state/tilt_state.dart';

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
    final TiltState tiltState = TiltState.of(context)!;

    return TiltTouchListener(
      onPointerMove: (e) => tiltState.onMove(e.localPosition),
      onPointerUp: (e) => tiltState.onStop(e.localPosition),
      onPointerCancel: (e) => tiltState.onStop(e.localPosition),
      child: TiltMouseListener(
        onHover: (e) => tiltState.onMove(e.localPosition),
        onExit: (e) => tiltState.onStop(e.localPosition),
        child: widget.child,
      ),
    );
  }
}
