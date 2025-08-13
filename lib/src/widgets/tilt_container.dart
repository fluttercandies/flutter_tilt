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
  late TiltState _tiltState;

  /// 是否初始化
  late bool _isInit;

  /// 尺寸
  late double _width, _height;

  /// 当前坐标区域进度
  late Offset _areaProgress;

  /// 是否正在移动
  late bool _isMove;

  /// 当前手势类型
  late GesturesType _currentGesturesType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tiltState = TiltState.of(context);

    _isInit = _tiltState.isInit;
    _width = _tiltState.width;
    _height = _tiltState.height;
    _areaProgress = _tiltState.areaProgress;
    _isMove = _tiltState.isMove;
    _currentGesturesType = _tiltState.currentGesturesType;
  }

  @override
  Widget build(BuildContext context) {
    final Offset animationEnd = tiltTweenAnimationEnd(
      _isMove,
      widget.tiltConfig,
      _areaProgress,
    );
    final Duration animationDuration = tiltTweenAnimationDuration(
      _isMove,
      _currentGesturesType,
      widget.tiltConfig,
    );
    final Curve animationCurve = tiltTweenAnimationCurve(
      _isMove,
      _currentGesturesType,
      widget.tiltConfig,
    );

    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(end: animationEnd),
      duration: animationDuration,
      curve: animationCurve,
      builder: (BuildContext context, Offset areaProgress, Widget? child) {
        final TiltData tiltData = TiltData(
          isInit: _isInit,
          width: _width,
          height: _height,
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
            children: _buildLightShadowMode(areaProgress, child),
          ),
        );
      },
      child: widget.child,
    );
  }

  List<Widget> _buildLightShadowMode(Offset areaProgress, Widget? child) {
    return switch (widget.lightShadowMode) {
      LightShadowMode.base => _buildLightShadowModeBase(
          areaProgress: areaProgress,
          child: child,
        ),
      LightShadowMode.projector => _buildLightShadowModeProjector(
          areaProgress: areaProgress,
          child: child,
        )
    };
  }

  /// LightShadowMode - Base
  List<Widget> _buildLightShadowModeBase({
    required Widget? child,
    required Offset areaProgress,
  }) {
    return [
      /// behind child
      ...widget.childLayout.behind,

      /// main child
      TiltShadowBase(
        width: _width,
        height: _height,
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
            width: _width,
            height: _height,
            areaProgress: areaProgress,
            lightConfig: widget.lightConfig,
          ),

          /// resize
          _widgetResize(),
        ]),
      ),

      /// outer child
      ...widget.childLayout.outer,
    ];
  }

  /// LightShadowMode - Projector
  List<Widget> _buildLightShadowModeProjector({
    required Widget? child,
    required Offset areaProgress,
  }) {
    return [
      /// shadow
      TiltShadowProjector(
        width: _width,
        height: _height,
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
          _widgetResize(),
        ]),
      ),

      /// outer child
      ...widget.childLayout.outer,

      /// light
      IgnorePointer(
        child: Transform.scale(
          scale: widget.lightConfig.projectorScale,
          child: Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
            ),
            clipBehavior: widget.clipBehavior,
            child: _buildStackInner(<Widget>[
              TiltLight(
                width: _width,
                height: _height,
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
  Widget _widgetResize() {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _tiltState.onResize(constraints.biggest);
            }
          });
          return const SizedBox();
        },
      ),
    );
  }
}
