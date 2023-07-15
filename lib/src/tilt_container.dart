import 'package:flutter/material.dart';

import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';
import 'package:flutter_tilt/src/type/tilt_shadow_type.dart';

import 'package:flutter_tilt/src/tilt_light.dart';
import 'package:flutter_tilt/src/tilt_shadow.dart';

import 'package:flutter_tilt/src/state/tilt_state.dart';

class TiltContainer extends StatefulWidget {
  const TiltContainer({
    Key? key,
    required this.child,
    this.borderRadius,
    required this.clipBehavior,
    required this.tiltConfig,
    required this.lightConfig,
    required this.shadowConfig,
  }) : super(key: key);

  final Widget child;

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

class _TiltContainerState extends State<TiltContainer> {
  late TiltState tiltState;

  late double width;
  late double height;

  /// 初始坐标区域进度
  late Offset initAreaProgress = _tiltConfig.initTilt ?? Offset.zero;

  /// 当前坐标区域进度
  late Offset areaProgress = initAreaProgress;

  /// 是否正在移动
  late bool isMove;

  /// 倾斜配置
  late final TiltConfig _tiltConfig = widget.tiltConfig;

  /// 光源配置
  late final LightConfig _lightConfig = widget.lightConfig;

  /// 阴影配置
  late final ShadowConfig _shadowConfig = widget.shadowConfig;

  /// 是否禁用光源
  late bool lightDisable = _lightConfig.disable ||
      _lightConfig.direction == LightDirection.none ||
      _lightConfig.intensity == 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tiltState = TiltState.of(context)!;

    width = tiltState.width;
    height = tiltState.height;
    areaProgress = tiltState.areaProgress;
    isMove = tiltState.isMove;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: isMove ? 100 : 300),
      tween: Tween<Offset>(end: isMove ? areaProgress : initAreaProgress),
      builder: (BuildContext context, Offset value, Widget? child) {
        return IgnorePointer(
          ignoring: false,
          child: Transform(
            alignment: AlignmentDirectional.center,
            transform: tiltTransform(
              width,
              height,
              value,
              _tiltConfig.angle,
              _tiltConfig.isReverse,
            ),
            child: TiltShadow(
              width: width,
              height: height,
              areaProgress: value,
              borderRadius: widget.borderRadius,
              clipBehavior: widget.clipBehavior,
              tiltConfig: _tiltConfig,
              lightConfig: _lightConfig,
              shadowConfig: _shadowConfig,
              child: Stack(
                alignment: AlignmentDirectional.center,

                /// 避免暴露其他组件，[Clip.none] 时，默认赋值 [Clip.hardEdge]
                clipBehavior: widget.clipBehavior == Clip.none
                    ? Clip.hardEdge
                    : widget.clipBehavior,
                children: [
                  /// Body
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                    ),
                    clipBehavior: widget.clipBehavior,
                    child: child,
                  ),

                  /// Light
                  if (!lightDisable)
                    TiltLight(
                      width: width,
                      height: height,
                      areaProgress: value,
                      borderRadius: widget.borderRadius,
                      clipBehavior: widget.clipBehavior,
                      tiltConfig: _tiltConfig,
                      lightConfig: _lightConfig,
                    ),

                  /// Resize
                  Positioned.fill(
                    child: LayoutBuilder(builder: (context, constraints) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => tiltState.onResize(constraints.biggest),
                      );
                      return const SizedBox();
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
