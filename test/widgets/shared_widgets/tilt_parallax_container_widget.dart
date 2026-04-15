import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

class TiltParallaxContainerWidget extends StatelessWidget {
  const TiltParallaxContainerWidget({
    super.key,
    this.childLayout,
    this.tiltStreamController,
    this.disable = false,
    this.fps = 60,
    this.border,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.tiltConfig = const TiltConfig(),
    this.lightConfig = const LightConfig(),
    this.shadowConfig = const ShadowBaseConfig(),
    this.onGestureMove,
    this.onGestureLeave,
  });

  final ChildLayout? childLayout;
  final StreamController<TiltStreamModel>? tiltStreamController;
  final bool disable;
  final int fps;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final Clip clipBehavior;
  final TiltConfig tiltConfig;
  final LightConfig lightConfig;
  final ShadowBaseConfig shadowConfig;
  final void Function(TiltDataModel, GesturesType)? onGestureMove;
  final void Function(TiltDataModel, GesturesType)? onGestureLeave;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: const Key('tilt_scaffold'),
        body: SizedBox(
          width: 30,
          height: 30,
          child: Center(
            child: Tilt(
              key: const Key('tilt_widget'),
              tiltStreamController: tiltStreamController,
              disable: disable,
              fps: fps,
              tiltConfig: tiltConfig.copyWith(enableGestureSensors: false),
              onGestureMove: onGestureMove,
              onGestureLeave: onGestureLeave,
              child: TiltBaseContainer(
                border: border,
                borderRadius: borderRadius,
                clipBehavior: clipBehavior,
                lightConfig: lightConfig,
                shadowConfig: shadowConfig,
                childLayout: childLayout ??
                    const ChildLayout(
                      outer: <Widget>[
                        Positioned(
                          child: TiltParallax(
                            child: SizedBox(
                              width: 10,
                              height: 10,
                              child: Text('outer'),
                            ),
                          ),
                        ),
                      ],
                      inner: <Widget>[
                        Positioned(
                          child: TiltParallax(
                            child: SizedBox(
                              width: 10,
                              height: 10,
                              child: Text('inner'),
                            ),
                          ),
                        ),
                      ],
                      behind: <Widget>[
                        Positioned(
                          child: TiltParallax(
                            child: SizedBox(
                              width: 10,
                              height: 10,
                              child: Text('behind'),
                            ),
                          ),
                        ),
                      ],
                    ),
                child: const SizedBox(
                  width: 10,
                  height: 10,
                  child: Text('Tilt'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
