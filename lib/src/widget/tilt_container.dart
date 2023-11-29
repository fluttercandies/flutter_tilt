import 'package:flutter/widgets.dart';

import 'tilt_light.dart';
import 'tilt_shadow.dart';
import '../enums.dart';
import '../data/tilt_data.dart';
import '../state/tilt_state.dart';
import '../config/tilt_light_config.dart';
import '../config/tilt_shadow_config.dart';
import '../config/tilt_config.dart';
import '../internal/tilt_tween_animation_mixin.dart';

class TiltContainer extends StatefulWidget {
  const TiltContainer({
    super.key,
    required this.child,
    required this.childLayout,
    this.border,
    this.borderRadius,
    required this.clipBehavior,
    required this.tiltConfig,
    required this.lightConfig,
    required this.shadowConfig,
  });

  /// 主 child
  final Widget child;

  /// child 其他布局
  final ChildLayout childLayout;

  /// Border
  final BoxBorder? border;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// Clip
  final Clip clipBehavior;

  /// 倾斜配置
  final TiltConfig tiltConfig;

  /// 光源配置
  final LightConfig lightConfig;

  /// 阴影配置
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
            children: <Widget>[
              /// behind child
              ..._childLayout.behind,

              /// main child
              TiltShadow(
                width: width,
                height: height,
                areaProgress: value,
                border: _border,
                borderRadius: _borderRadius,
                clipBehavior: _clipBehavior,
                lightConfig: _lightConfig,
                shadowConfig: _shadowConfig,
                child: Stack(
                  alignment: AlignmentDirectional.center,

                  /// 避免暴露其他组件，[Clip.none] 时，默认赋值 [Clip.hardEdge]
                  clipBehavior: _clipBehavior == Clip.none
                      ? Clip.hardEdge
                      : _clipBehavior,
                  children: <Widget>[
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
                      areaProgress: value,
                      lightConfig: _lightConfig,
                    ),

                    /// resize
                    Positioned.fill(
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
                    ),
                  ],
                ),
              ),

              /// outer child
              ..._childLayout.outer,
            ],
          ),
        );
      },
      child: _child,
    );
  }
}
