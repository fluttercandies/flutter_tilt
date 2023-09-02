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
                    enableSensors: false,
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
                    enableSensors: true,
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
                    enableSensors: true,
                  ),
                );
              }
            : null,
        child: MouseRegion(
          onHover: _tiltConfig.enableGestureHover && !isTouch
              ? (PointerHoverEvent e) {
                  _tiltStreamController.add(
                    TiltStream(
                      position: e.localPosition,
                      gesturesType: GesturesType.hover,
                      enableSensors: false,
                    ),
                  );
                }
              : null,
          onExit: _tiltConfig.enableGestureHover && !isTouch
              ? (PointerExitEvent e) {
                  _tiltStreamController.add(
                    TiltStream(
                      position: e.localPosition,
                      gesturesType: GesturesType.hover,
                      enableSensors: true,
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
