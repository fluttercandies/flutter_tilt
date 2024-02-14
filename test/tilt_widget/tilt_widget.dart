import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

class TiltWidget extends StatelessWidget {
  const TiltWidget({
    super.key,
    this.childLayout = const ChildLayout(),
    this.tiltStreamController,
    this.disable = false,
    this.fps = 60,
    this.border,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.tiltConfig = const TiltConfig(),
    this.lightConfig = const LightConfig(),
    this.shadowConfig = const ShadowConfig(),
    this.onGestureMove,
    this.onGestureLeave,
  });

  final ChildLayout childLayout;
  final StreamController<TiltStreamModel>? tiltStreamController;
  final bool disable;
  final int fps;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final Clip clipBehavior;
  final TiltConfig tiltConfig;
  final LightConfig lightConfig;
  final ShadowConfig shadowConfig;
  final void Function(TiltDataModel, GesturesType)? onGestureMove;
  final void Function(TiltDataModel, GesturesType)? onGestureLeave;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: const Key('tilt_scaffold'),
        body: Tilt(
          key: const Key('tilt_widget'),
          childLayout: childLayout,
          tiltStreamController: tiltStreamController,
          disable: disable,
          fps: fps,
          border: border,
          borderRadius: borderRadius,
          clipBehavior: clipBehavior,
          tiltConfig: tiltConfig,
          lightConfig: lightConfig,
          shadowConfig: shadowConfig,
          onGestureMove: onGestureMove,
          onGestureLeave: onGestureLeave,
          child: const SizedBox(
            width: 10,
            height: 10,
            child: Text('Tilt'),
          ),
        ),
      ),
    );
  }
}
