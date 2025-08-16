import 'package:flutter/widgets.dart';

import '../config/tilt_config.dart';
import '../config/tilt_light_config.dart';
import '../config/tilt_shadow_config.dart';
import '../enums.dart';
import '../internal/mixin/tilt_tween_animation_mixin.dart';
import '../internal/tilt_data.dart';
import '../internal/tilt_state.dart';
import 'tilt_light.dart';
import 'tilt_shadow.dart';

class TiltContainer extends StatefulWidget {
  const TiltContainer({
    super.key,
    required this.child,
    required this.childLayout,
    this.border,
    this.borderRadius,
    required this.clipBehavior,
    required this.tiltConfig,
    this.lightShadowMode = LightShadowMode.base,
    required this.lightConfig,
    required this.shadowConfig,
  });

  final Widget child;

  /// Other child layouts. e.g. [TiltParallax] parallax inner, outer, behind.
  ///
  /// ------
  ///
  /// 其他 child 布局。例如：位于 child 内部、外部、后面的视差布局 [TiltParallax]。
  ///
  final ChildLayout childLayout;

  /// BoxDecoration border.
  ///
  /// ------
  ///
  /// BoxDecoration 边框样式。
  final BoxBorder? border;

  /// BoxDecoration borderRadius.
  ///
  /// ------
  ///
  /// BoxDecoration 边框圆角半径。
  final BorderRadiusGeometry? borderRadius;

  /// Clip
  final Clip clipBehavior;

  /// Tilt effect config.
  ///
  /// ------
  ///
  /// 倾斜效果配置。
  final TiltConfig tiltConfig;

  /// Light & Shadow Mode.
  ///
  /// ------
  ///
  /// 光影模式。
  final LightShadowMode lightShadowMode;

  /// Light effect config.
  ///
  /// ------
  ///
  /// 光照效果配置。
  final LightConfig lightConfig;

  /// Shadow effect config.
  ///
  /// ------
  ///
  /// 阴影效果配置。
  final ShadowConfig shadowConfig;

  @override
  State<TiltContainer> createState() => _TiltContainerState();
}

class _TiltContainerState extends State<TiltContainer> with TiltTweenAnimation {
  @override
  Widget build(BuildContext context) {
    final tiltState = TiltState.of(context);
    final animationEnd = tiltTweenAnimationEnd(
      tiltState.isMove,
      widget.tiltConfig,
      tiltState.areaProgress,
    );
    final animationDuration = tiltTweenAnimationDuration(
      tiltState.isMove,
      tiltState.currentGesturesType,
      widget.tiltConfig,
    );
    final animationCurve = tiltTweenAnimationCurve(
      tiltState.isMove,
      tiltState.currentGesturesType,
      widget.tiltConfig,
    );

    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(end: animationEnd),
      duration: animationDuration,
      curve: animationCurve,
      builder: (BuildContext context, Offset areaProgress, Widget? child) {
        final tiltData = TiltData(
          isInit: tiltState.isInit,
          width: tiltState.width,
          height: tiltState.height,
          areaProgress: areaProgress,
          tiltConfig: widget.tiltConfig,
        );

        return Transform(
          alignment: AlignmentDirectional.center,
          filterQuality: widget.tiltConfig.filterQuality,
          transform: tiltData.transform,
          child: Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: _buildLightShadowMode(
              width: tiltState.width,
              height: tiltState.height,
              areaProgress: areaProgress,
              onResize: tiltState.onResize,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }

  /// Build LightShadowMode widgets
  ///
  /// - [child]
  /// - [width] 宽度
  /// - [height] 高度
  /// - [areaProgress] 区域进度
  /// - [onResize] 调整尺寸回调
  List<Widget> _buildLightShadowMode({
    Widget? child,
    required double width,
    required double height,
    required Offset areaProgress,
    required void Function(Size) onResize,
  }) {
    return switch (widget.lightShadowMode) {
      LightShadowMode.base => _buildLightShadowModeBase(
          width: width,
          height: height,
          areaProgress: areaProgress,
          onResize: onResize,
          child: child,
        ),
      LightShadowMode.projector => _buildLightShadowModeProjector(
          width: width,
          height: height,
          areaProgress: areaProgress,
          onResize: onResize,
          child: child,
        )
    };
  }

  /// LightShadowMode - Base
  ///
  /// - [child]
  /// - [width] 宽度
  /// - [height] 高度
  /// - [areaProgress] 区域进度
  /// - [onResize] 调整尺寸回调
  List<Widget> _buildLightShadowModeBase({
    Widget? child,
    required double width,
    required double height,
    required Offset areaProgress,
    required void Function(Size) onResize,
  }) {
    return [
      /// behind child
      ...widget.childLayout.behind,

      /// main child
      TiltShadowBase(
        width: width,
        height: height,
        areaProgress: areaProgress,
        border: widget.border,
        borderRadius: widget.borderRadius,
        clipBehavior: widget.clipBehavior,
        lightConfig: widget.lightConfig,
        shadowConfig: widget.shadowConfig,
        child: _buildStackInner(<Widget>[
          /// body
          Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
            ),
            clipBehavior: widget.clipBehavior,
            child: child,
          ),

          /// inner child
          ...widget.childLayout.inner,

          /// light
          TiltLight(
            width: width,
            height: height,
            areaProgress: areaProgress,
            lightConfig: widget.lightConfig,
          ),

          /// resize
          _widgetResize(onResize),
        ]),
      ),

      /// outer child
      ...widget.childLayout.outer,
    ];
  }

  /// LightShadowMode - Projector
  ///
  /// - [child]
  /// - [width] 宽度
  /// - [height] 高度
  /// - [areaProgress] 区域进度
  /// - [onResize] 调整尺寸回调
  List<Widget> _buildLightShadowModeProjector({
    Widget? child,
    required double width,
    required double height,
    required Offset areaProgress,
    required void Function(Size) onResize,
  }) {
    return [
      /// shadow
      TiltShadowProjector(
        width: width,
        height: height,
        areaProgress: areaProgress,
        lightConfig: widget.lightConfig,
        shadowConfig: widget.shadowConfig,
        child: Stack(
          alignment: AlignmentDirectional.center,
          clipBehavior: Clip.none,
          children: [
            /// behind child
            ...widget.childLayout.behind,

            /// main child
            Container(
              decoration: BoxDecoration(
                border: widget.border,
                borderRadius: widget.borderRadius,
              ),
              clipBehavior: widget.clipBehavior,
              child: _buildStackInner(<Widget>[
                /// body
                child ?? const SizedBox(),

                /// inner child
                ...widget.childLayout.inner,
              ]),
            ),

            /// outer child
            ...widget.childLayout.outer,
          ],
        ),
      ),

      /// behind child
      ...widget.childLayout.behind,

      /// main child
      Container(
        decoration: BoxDecoration(
          border: widget.border,
          borderRadius: widget.borderRadius,
        ),
        clipBehavior: widget.clipBehavior,
        child: _buildStackInner(<Widget>[
          /// body
          child ?? const SizedBox(),

          /// inner child
          ...widget.childLayout.inner,

          /// resize
          _widgetResize(onResize),
        ]),
      ),

      /// outer child
      ...widget.childLayout.outer,

      /// light
      IgnorePointer(
        child: Transform.scale(
          scale: widget.lightConfig.projectorScale,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
            ),
            clipBehavior: widget.clipBehavior,
            child: _buildStackInner(<Widget>[
              TiltLight(
                width: width,
                height: height,
                areaProgress: areaProgress,
                lightConfig: widget.lightConfig,
              ),
            ]),
          ),
        ),
      ),
    ];
  }

  /// Stack Inner
  Widget _buildStackInner(List<Widget> children) {
    return Stack(
      alignment: AlignmentDirectional.center,

      /// 避免暴露其他组件，[Clip.none] 时，默认赋值 [Clip.hardEdge]
      clipBehavior: widget.clipBehavior == Clip.none
          ? Clip.hardEdge
          : widget.clipBehavior,
      children: children,
    );
  }

  /// Widget Resize
  Widget _widgetResize(void Function(Size) onResize) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              onResize(constraints.biggest);
            }
          });
          return const SizedBox();
        },
      ),
    );
  }
}
