import 'dart:async' as async;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/model/tilt_model.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';

/// 手势监听
class GesturesListener extends StatefulWidget {
  /// 手势监听
  ///
  /// 对 Touch [Listener] 和 Mouse [MouseRegion] 的监听触发
  const GesturesListener({
    super.key,
    required this.child,
    required this.tiltStreamController,
    required this.tiltConfig,
  });

  final Widget child;

  /// TiltStreamController
  final async.StreamController<TiltStream> tiltStreamController;

  final TiltConfig tiltConfig;

  @override
  State<GesturesListener> createState() => _GesturesListenerState();
}

class _GesturesListenerState extends State<GesturesListener> {
  Widget get _child => widget.child;
  async.StreamController<TiltStream> get _tiltStreamController =>
      widget.tiltStreamController;
  TiltConfig get _tiltConfig => widget.tiltConfig;

  /// 避免 touch 和 hover 同时触发，导致 hover 离开的时候会“闪现”
  bool isTouch = false;

  /// 避免 hover 未 Enter 时就触发
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    /// 不受滑动影响
    return GestureDetector(
      onVerticalDragUpdate: (_) {},
      onHorizontalDragUpdate: (_) {},

      /// 手势监听
      child: Listener(
        onPointerMove: _tiltConfig.enableGestureTouch
            ? (PointerMoveEvent e) {
                isTouch = true;
                _tiltStreamController.add(
                  TiltStream(
                    position: e.localPosition,
                    gesturesType: GesturesType.touch,
                    enableRevert: false,
                  ),
                );
              }
            : null,
        onPointerUp: _tiltConfig.enableGestureTouch
            ? (PointerUpEvent e) {
                isTouch = false;
                _tiltStreamController.add(
                  TiltStream(
                    position: e.localPosition,
                    gesturesType: GesturesType.touch,
                    enableRevert: true,
                  ),
                );
              }
            : null,
        onPointerCancel: _tiltConfig.enableGestureTouch
            ? (PointerCancelEvent e) {
                isTouch = false;
                _tiltStreamController.add(
                  TiltStream(
                    position: e.localPosition,
                    gesturesType: GesturesType.touch,
                    enableRevert: true,
                  ),
                );
              }
            : null,
        child: MouseRegion(
          onEnter: _tiltConfig.enableGestureHover
              ? (PointerEnterEvent e) {
                  if (isTouch) return;
                  isHover = true;
                }
              : null,
          onHover: _tiltConfig.enableGestureHover
              ? (PointerHoverEvent e) {
                  if (isHover) {
                    if (isTouch) return;
                    _tiltStreamController.add(
                      TiltStream(
                        position: e.localPosition,
                        gesturesType: GesturesType.hover,
                        enableRevert: false,
                      ),
                    );
                  }
                }
              : null,
          onExit: _tiltConfig.enableGestureHover
              ? (PointerExitEvent e) {
                  if (isTouch) return;
                  isHover = false;
                  _tiltStreamController.add(
                    TiltStream(
                      position: e.localPosition,
                      gesturesType: GesturesType.hover,
                      enableRevert: true,
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
