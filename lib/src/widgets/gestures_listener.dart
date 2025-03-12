import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../enums.dart';
import '../internal/controllers/tilt_gestures_controller.dart';
import '../models/tilt_stream_model.dart';

/// 手势监听
class GesturesListener extends StatefulWidget {
  /// 手势监听
  ///
  /// 对 Touch [Listener] 和 Mouse [MouseRegion] 的监听触发
  const GesturesListener({
    super.key,
    required this.child,
    required this.tiltGesturesController,
  });

  final Widget child;

  /// 倾斜手势控制器
  final TiltGesturesController tiltGesturesController;

  @override
  State<GesturesListener> createState() => _GesturesListenerState();
}

class _GesturesListenerState extends State<GesturesListener> {
  Widget get _child => widget.child;
  TiltGesturesController get _tiltGesturesController =>
      widget.tiltGesturesController;

  /// 避免 touch 和 hover 同时触发，导致 hover 离开的时候会“闪现”
  bool isTouch = false;

  /// 避免 hover 未 Enter 时就触发
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    if (_tiltGesturesController.disable) return _child;

    /// 不受滑动影响
    return GestureDetector(
      onVerticalDragUpdate:
          _tiltGesturesController.tiltConfig.enableGestureTouch ? (_) {} : null,
      onHorizontalDragUpdate:
          _tiltGesturesController.tiltConfig.enableGestureTouch ? (_) {} : null,

      /// 手势监听
      child: Listener(
        onPointerMove: _tiltGesturesController.tiltConfig.enableGestureTouch
            ? (PointerMoveEvent e) {
                isTouch = true;
                _tiltGesturesController.tiltStreamController.sink.add(
                  TiltStreamModel(
                    position: e.localPosition,
                    gesturesType: GesturesType.touch,
                    gestureUse: true,
                  ),
                );
              }
            : null,
        onPointerUp: _tiltGesturesController.tiltConfig.enableGestureTouch
            ? (PointerUpEvent e) {
                isTouch = false;
                _tiltGesturesController.tiltStreamController.sink.add(
                  TiltStreamModel(
                    position: e.localPosition,
                    gesturesType: GesturesType.touch,
                    gestureUse: false,
                  ),
                );
              }
            : null,
        onPointerCancel: _tiltGesturesController.tiltConfig.enableGestureTouch
            ? (PointerCancelEvent e) {
                isTouch = false;
                _tiltGesturesController.tiltStreamController.sink.add(
                  TiltStreamModel(
                    position: e.localPosition,
                    gesturesType: GesturesType.touch,
                    gestureUse: false,
                  ),
                );
              }
            : null,
        child: MouseRegion(
          onEnter: _tiltGesturesController.tiltConfig.enableGestureHover
              ? (PointerEnterEvent e) {
                  if (isTouch) return;
                  isHover = true;
                }
              : null,
          onHover: _tiltGesturesController.tiltConfig.enableGestureHover
              ? (PointerHoverEvent e) {
                  if (isHover) {
                    if (isTouch) return;
                    _tiltGesturesController.tiltStreamController.sink.add(
                      TiltStreamModel(
                        position: e.localPosition,
                        gesturesType: GesturesType.hover,
                        gestureUse: true,
                      ),
                    );
                  }
                }
              : null,
          onExit: _tiltGesturesController.tiltConfig.enableGestureHover
              ? (PointerExitEvent e) {
                  if (isTouch) return;
                  isHover = false;
                  _tiltGesturesController.tiltStreamController.sink.add(
                    TiltStreamModel(
                      position: e.localPosition,
                      gesturesType: GesturesType.hover,
                      gestureUse: false,
                    ),
                  );
                }
              : null,
          child: _child,
        ),
      ),
    );
  }
}
