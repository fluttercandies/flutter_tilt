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
  bool get _enableGestureTouch =>
      widget.tiltGesturesController.tiltConfig.enableGestureTouch;
  bool get _enableGestureHover =>
      widget.tiltGesturesController.tiltConfig.enableGestureHover;

  /// 避免 touch 和 hover 同时触发，导致 hover 离开的时候会“闪现”
  bool _isTouch = false;

  /// 避免 hover 未 Enter 时就触发
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    if (widget.tiltGesturesController.disable) return widget.child;

    /// 不受滑动影响
    return GestureDetector(
      onVerticalDragUpdate: _enableGestureTouch ? (_) {} : null,
      onHorizontalDragUpdate: _enableGestureTouch ? (_) {} : null,
      child: Listener(
        onPointerMove: _enableGestureTouch ? _handlePointerMove : null,
        onPointerUp: _enableGestureTouch ? _handlePointerUp : null,
        onPointerCancel: _enableGestureTouch ? _handlePointerCancel : null,
        child: MouseRegion(
          onEnter: _enableGestureHover ? _handleMouseEnter : null,
          onHover: _enableGestureHover ? _handleMouseHover : null,
          onExit: _enableGestureHover ? _handleMouseExit : null,
          child: widget.child,
        ),
      ),
    );
  }

  void _handlePointerMove(PointerMoveEvent e) {
    _isTouch = true;
    _addToTiltStream(e.localPosition, GesturesType.touch, true);
  }

  void _handlePointerUp(PointerUpEvent e) {
    _isTouch = false;
    _addToTiltStream(e.localPosition, GesturesType.touch, false);
  }

  void _handlePointerCancel(PointerCancelEvent e) {
    _isTouch = false;
    _addToTiltStream(e.localPosition, GesturesType.touch, false);
  }

  void _handleMouseEnter(PointerEnterEvent e) {
    if (_isTouch) return;
    _isHover = true;
  }

  void _handleMouseHover(PointerHoverEvent e) {
    if (!_isHover || _isTouch) return;
    _addToTiltStream(e.localPosition, GesturesType.hover, true);
  }

  void _handleMouseExit(PointerExitEvent e) {
    if (_isTouch) return;
    _isHover = false;
    _addToTiltStream(e.localPosition, GesturesType.hover, false);
  }

  /// 添加到 Stream
  ///
  /// - [position] 当前位置
  /// - [gesturesType] 手势类型
  /// - [gestureUse] 手势是否使用
  void _addToTiltStream(
    Offset position,
    GesturesType gesturesType,
    bool gestureUse,
  ) {
    widget.tiltGesturesController.tiltStreamController.sink.add(
      TiltStreamModel(
        position: position,
        gesturesType: gesturesType,
        gestureUse: gestureUse,
      ),
    );
  }
}
