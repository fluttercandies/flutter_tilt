import 'package:flutter/widgets.dart';

import 'config/tilt_config.dart';
import 'config/tilt_light_config.dart';
import 'config/tilt_shadow_config.dart';
import 'widgets/containers/tilt_base_container.dart';
import 'widgets/containers/tilt_parallax_container.dart';
import 'widgets/containers/tilt_projector_container.dart';
import 'widgets/core/tilt_widget.dart';

/// Tilt
/// 倾斜
class Tilt extends TiltWidget {
  /// Tilt
  /// 倾斜
  ///
  /// {@macro tilt.TiltWidget.desc.en}
  /// {@macro tilt.TiltWidget.param.en}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltWidget.desc.zh}
  /// {@macro tilt.TiltWidget.param.zh}
  const Tilt({
    super.key,
    required super.child,
    super.tiltStreamController,
    super.disable,
    super.fps,
    super.tiltConfig,
    super.onGestureMove,
    super.onGestureLeave,
  });

  /// Tilt with built-in [TiltBaseContainer].
  ///
  /// {@macro tilt.TiltBaseContainer.desc.en}
  ///
  /// {@macro tilt.TiltWidget.param.en}
  ///
  /// {@macro tilt.TiltBaseContainer.param.en}
  ///
  /// ------
  ///
  /// 内置 [TiltBaseContainer] 的 Tilt。
  ///
  /// {@macro tilt.TiltBaseContainer.desc.zh}
  ///
  /// {@macro tilt.TiltWidget.param.zh}
  ///
  /// {@macro tilt.TiltBaseContainer.param.zh}
  Tilt.base({
    super.key,
    required Widget child,
    super.tiltStreamController,
    super.disable,
    super.fps,
    super.tiltConfig,
    super.onGestureMove,
    super.onGestureLeave,
    ChildLayout childLayout = const ChildLayout(),
    LightConfig lightConfig = const LightConfig(),
    ShadowBaseConfig shadowConfig = const ShadowBaseConfig(),
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
    FilterQuality? filterQuality,
  }) : super(
          child: TiltBaseContainer(
            childLayout: childLayout,
            lightConfig: lightConfig,
            shadowConfig: shadowConfig,
            border: border,
            borderRadius: borderRadius,
            clipBehavior: clipBehavior,
            filterQuality: filterQuality,
            child: child,
          ),
        );

  /// Tilt with built-in [TiltProjectorContainer].
  ///
  /// {@macro tilt.TiltProjectorContainer.desc.en}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltWidget.param.en}
  ///
  /// {@macro tilt.TiltProjectorContainer.param.en}
  ///
  /// ------
  ///
  /// 内置 [TiltProjectorContainer] 的 Tilt。
  ///
  /// {@macro tilt.TiltProjectorContainer.desc.zh}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltWidget.param.zh}
  ///
  /// {@macro tilt.TiltProjectorContainer.param.zh}
  Tilt.projector({
    super.key,
    required Widget child,
    super.tiltStreamController,
    super.disable,
    super.fps,
    super.tiltConfig,
    super.onGestureMove,
    super.onGestureLeave,
    ChildLayout childLayout = const ChildLayout(),
    LightProjectorConfig lightConfig = const LightProjectorConfig(),
    ShadowProjectorConfig shadowConfig = const ShadowProjectorConfig(),
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
    FilterQuality? filterQuality,
  }) : super(
          child: TiltProjectorContainer(
            childLayout: childLayout,
            lightConfig: lightConfig,
            shadowConfig: shadowConfig,
            border: border,
            borderRadius: borderRadius,
            clipBehavior: clipBehavior,
            filterQuality: filterQuality,
            child: child,
          ),
        );
}

/// TiltParallax
/// 倾斜视差
class TiltParallax extends TiltParallaxContainer {
  /// TiltParallax
  /// 倾斜视差
  ///
  /// {@macro tilt.TiltParallaxContainer.desc.en}
  ///
  /// {@macro tilt.TiltParallaxContainer.param.en}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltParallaxContainer.desc.zh}
  ///
  /// {@macro tilt.TiltParallaxContainer.param.zh}
  const TiltParallax({
    super.key,
    required super.child,
    super.size = const Offset(10.0, 10.0),
    super.filterQuality,
  });
}
