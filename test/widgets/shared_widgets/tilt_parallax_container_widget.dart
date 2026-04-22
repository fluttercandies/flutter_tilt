import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:flutter_tilt/src/widgets/containers/tilt_parallax_container.dart';

class TiltParallaxContainerWidget extends StatelessWidget {
  const TiltParallaxContainerWidget({
    super.key,
    this.childLayout,
    this.tiltController,
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
  final TiltController? tiltController;
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
              tiltController: tiltController,
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
                          child: TiltParallaxContainer(
                            size: Offset(10, 10),
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
                          child: TiltParallaxContainer(
                            size: Offset(10, 10),
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
                          child: TiltParallaxContainer(
                            size: Offset(10, 10),
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
