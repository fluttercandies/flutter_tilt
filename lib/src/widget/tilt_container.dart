import 'package:flutter/widgets.dart';

import '../config/tilt_config.dart';
import '../config/tilt_light_config.dart';
import '../config/tilt_shadow_config.dart';
import '../data/tilt_data.dart';
import '../enums.dart';
import '../internal/tilt_tween_animation_mixin.dart';
import '../state/tilt_state.dart';
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
  Widget get _child => widget.child;
  ChildLayout get _childLayout => widget.childLayout;
  BoxBorder? get _border => widget.border;
  BorderRadiusGeometry? get _borderRadius => widget.borderRadius;
  Clip get _clipBehavior => widget.clipBehavior;
  TiltConfig get _tiltConfig => widget.tiltConfig;
  LightShadowMode get _lightShadowMode => widget.lightShadowMode;
  LightConfig get _lightConfig => widget.lightConfig;
  ShadowConfig get _shadowConfig => widget.shadowConfig;

  late TiltState tiltState;

  /// 是否初始化
  late bool isInit;

  /// 尺寸
  late double width, height;

  /// 当前坐标区域进度
  late Offset areaProgress;

  /// 是否正在移动
  late bool isMove;

  /// 当前手势类型
  late GesturesType currentGesturesType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tiltState = TiltState.of(context)!;

    isInit = tiltState.isInit;
    width = tiltState.width;
    height = tiltState.height;
    areaProgress = tiltState.areaProgress;
    isMove = tiltState.isMove;
    currentGesturesType = tiltState.currentGesturesType;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        end: tiltTweenAnimationEnd(isMove, _tiltConfig, areaProgress),
      ),
      duration:
          tiltTweenAnimationDuration(isMove, currentGesturesType, _tiltConfig),
      curve: tiltTweenAnimationCurve(isMove, currentGesturesType, _tiltConfig),
      builder: (BuildContext context, Offset value, Widget? child) {
        final TiltData tiltData = TiltData(
          isInit: isInit,
          width: width,
          height: height,
          areaProgress: value,
          tiltConfig: _tiltConfig,
        );

        return Transform(
          alignment: AlignmentDirectional.center,
          filterQuality: _tiltConfig.filterQuality,
          transform: tiltData.transform,
          child: Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: switch (_lightShadowMode) {
              LightShadowMode.base => lightShadowModeBase(
                  child: child,
                  areaProgress: value,
                ),
              LightShadowMode.projector => lightShadowModeProjector(
                  child: child,
                  areaProgress: value,
                ),
            },
          ),
        );
      },
      child: _child,
    );
  }

  /// Widget Resize
  Widget widgetResize() {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          WidgetsBinding.instance.endOfFrame.then((_) {
            if (mounted) {
              tiltState.onResize(constraints.biggest);
            }
          });
          return const SizedBox();
        },
      ),
    );
  }

  /// Stack Inner
  Widget stackInner(List<Widget> children) {
    return Stack(
      alignment: AlignmentDirectional.center,

      /// 避免暴露其他组件，[Clip.none] 时，默认赋值 [Clip.hardEdge]
      clipBehavior: _clipBehavior == Clip.none ? Clip.hardEdge : _clipBehavior,
      children: children,
    );
  }

  /// LightShadowMode - Base
  List<Widget> lightShadowModeBase({
    required Widget? child,
    required Offset areaProgress,
  }) {
    return [
      /// behind child
      ..._childLayout.behind,

      /// main child
      TiltShadowBase(
        width: width,
        height: height,
        areaProgress: areaProgress,
        border: _border,
        borderRadius: _borderRadius,
        clipBehavior: _clipBehavior,
        lightConfig: _lightConfig,
        shadowConfig: _shadowConfig,
        child: stackInner(<Widget>[
          /// body
          Container(
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
            ),
            clipBehavior: _clipBehavior,
            child: child,
          ),

          /// inner child
          ..._childLayout.inner,

          /// light
          TiltLight(
            width: width,
            height: height,
            areaProgress: areaProgress,
            lightConfig: _lightConfig,
          ),

          /// resize
          widgetResize(),
        ]),
      ),

      /// outer child
      ..._childLayout.outer,
    ];
  }

  /// LightShadowMode - Projector
  List<Widget> lightShadowModeProjector({
    required Widget? child,
    required Offset areaProgress,
  }) {
    return [
      /// shadow
      TiltShadowProjector(
        width: width,
        height: height,
        areaProgress: areaProgress,
        lightConfig: _lightConfig,
        shadowConfig: _shadowConfig,
        child: Stack(
          alignment: AlignmentDirectional.center,
          clipBehavior: Clip.none,
          children: [
            /// behind child
            ..._childLayout.behind,

            /// main child
            Container(
              decoration: BoxDecoration(
                border: _border,
                borderRadius: _borderRadius,
              ),
              clipBehavior: _clipBehavior,
              child: stackInner(<Widget>[
                /// body
                child ?? const SizedBox(),

                /// inner child
                ..._childLayout.inner,
              ]),
            ),

            /// outer child
            ..._childLayout.outer,
          ],
        ),
      ),

      /// behind child
      ..._childLayout.behind,

      /// main child
      Container(
        decoration: BoxDecoration(
          border: _border,
          borderRadius: _borderRadius,
        ),
        clipBehavior: _clipBehavior,
        child: stackInner(<Widget>[
          /// body
          child ?? const SizedBox(),

          /// inner child
          ..._childLayout.inner,

          /// resize
          widgetResize(),
        ]),
      ),

      /// outer child
      ..._childLayout.outer,

      /// light
      IgnorePointer(
        child: Transform.scale(
          scale: _lightConfig.projectorScale,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
            ),
            clipBehavior: _clipBehavior,
            child: stackInner(<Widget>[
              TiltLight(
                width: width,
                height: height,
                areaProgress: areaProgress,
                lightConfig: _lightConfig,
              ),
            ]),
          ),
        ),
      ),
    ];
  }
}
