import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../../controllers/tilt_controller.dart';
import '../../../enums.dart';
import 'tilt_action_input_source.dart';

/// 处理 touch 和 hover 的原始输入
class TiltPointerInputSource implements TiltActionInputSource {
  TiltPointerInputSource({required this.tiltController});

  final TiltController tiltController;

  /// 当前是否处于 touch 状态
  bool _isTouch = false;

  /// 当前是否处于 hover 状态
  bool _isHover = false;

  @override
  void init(BuildContext context) {}

  @override
  void dispose() {}

  void handlePointerMove(PointerMoveEvent event) {
    _isTouch = true;
    _move(event.localPosition, GesturesType.touch);
  }

  void handlePointerUp(PointerUpEvent event) {
    _isTouch = false;
    _leave(event.localPosition, GesturesType.touch);
  }

  void handlePointerCancel(PointerCancelEvent event) {
    _isTouch = false;
    _leave(event.localPosition, GesturesType.touch);
  }

  void handleMouseEnter(PointerEnterEvent event) {
    if (_isTouch) return;
    _isHover = true;
  }

  void handleMouseHover(PointerHoverEvent event) {
    if (!_isHover || _isTouch) return;
    _move(event.localPosition, GesturesType.hover);
  }

  void handleMouseExit(PointerExitEvent event) {
    if (_isTouch) return;
    _isHover = false;
    _leave(event.localPosition, GesturesType.hover);
  }

  void _move(Offset position, GesturesType gesturesType) {
    tiltController.move(position: position, gesturesType: gesturesType);
  }

  void _leave(Offset position, GesturesType gesturesType) {
    tiltController.leave(position: position, gesturesType: gesturesType);
  }
}
