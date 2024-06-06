import 'dart:async' as async;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../config/tilt_config.dart';
import '../data/tilt_data.dart';
import '../enums.dart';

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
  final async.StreamController<TiltStreamModel> tiltStreamController;

  final TiltConfig tiltConfig;

  @override
  State<GesturesListener> createState() => _GesturesListenerState();
}

class _GesturesListenerState extends State<GesturesListener> {
  Widget get _child => widget.child;
  async.StreamController<TiltStreamModel> get _tiltStreamController =>
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
                _tiltStreamController.sink.add(
                  TiltStreamModel(
                    position: e.localPosition,
                    gesturesType: GesturesType.touch,
                    gestureUse: true,
                  ),
                );
              }
            : null,
        onPointerUp: _tiltConfig.enableGestureTouch
            ? (PointerUpEvent e) {
                isTouch = false;
                _tiltStreamController.sink.add(
                  TiltStreamModel(
                    position: e.localPosition,
                    gesturesType: GesturesType.touch,
                    gestureUse: false,
                  ),
                );
              }
            : null,
        onPointerCancel: _tiltConfig.enableGestureTouch
            ? (PointerCancelEvent e) {
                isTouch = false;
                _tiltStreamController.sink.add(
                  TiltStreamModel(
                    position: e.localPosition,
                    gesturesType: GesturesType.touch,
                    gestureUse: false,
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
                    _tiltStreamController.sink.add(
                      TiltStreamModel(
                        position: e.localPosition,
                        gesturesType: GesturesType.hover,
                        gestureUse: true,
                      ),
                    );
                  }
                }
              : null,
          onExit: _tiltConfig.enableGestureHover
              ? (PointerExitEvent e) {
                  if (isTouch) return;
                  isHover = false;
                  _tiltStreamController.sink.add(
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
