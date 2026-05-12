import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../internal/action_input/sources/tilt_pointer_input_source.dart';

/// 手势监听
class GesturesListener extends StatelessWidget {
  /// 手势监听
  ///
  /// 对 Touch [Listener] 和 Mouse [MouseRegion] 的监听触发
  const GesturesListener({
    super.key,
    required this.child,
    required this.disable,
    required this.tiltConfig,
    required this.pointerInputSource,
  });

  final Widget child;
  final bool disable;
  final TiltConfig tiltConfig;
  final TiltPointerInputSource pointerInputSource;

  bool get _enableGestureTouch => tiltConfig.enableGestureTouch;
  bool get _enableGestureHover => tiltConfig.enableGestureHover;

  @override
  Widget build(BuildContext context) {
    if (disable) return child;

    /// 不受滑动影响
    return GestureDetector(
      onVerticalDragUpdate: _enableGestureTouch ? (_) {} : null,
      onHorizontalDragUpdate: _enableGestureTouch ? (_) {} : null,
      child: Listener(
        onPointerMove:
            _enableGestureTouch ? pointerInputSource.handlePointerMove : null,
        onPointerUp:
            _enableGestureTouch ? pointerInputSource.handlePointerUp : null,
        onPointerCancel:
            _enableGestureTouch ? pointerInputSource.handlePointerCancel : null,
        child: MouseRegion(
          onEnter:
              _enableGestureHover ? pointerInputSource.handleMouseEnter : null,
          onHover:
              _enableGestureHover ? pointerInputSource.handleMouseHover : null,
          onExit:
              _enableGestureHover ? pointerInputSource.handleMouseExit : null,
          child: child,
        ),
      ),
    );
  }
}
