import 'package:flutter/material.dart';

import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';
import 'package:flutter_tilt/src/type/tilt_shadow_type.dart';

import 'package:flutter_tilt/src/tilt_light.dart';
import 'package:flutter_tilt/src/tilt_shadow.dart';

import 'package:flutter_tilt/src/state/tilt_state.dart';

class TiltContainer extends StatefulWidget {
  const TiltContainer({
    Key? key,
    required this.child,
    this.initTilt,
    required this.angle,
    this.borderRadius,
    required this.clipBehavior,
    required this.lightConfig,
    required this.shadowConfig,
  }) : super(key: key);

  final Widget child;

  /// 初始倾斜量
  ///
  /// {@macro tilt.initTilt}
  final Offset? initTilt;

  /// 可倾斜角度
  ///
  /// {@macro tilt.angle}
  final double angle;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// Clip
  final Clip clipBehavior;

  /// 光源配置
  final LightConfig lightConfig;

  /// 阴影配置
  final ShadowConfig shadowConfig;

  @override
  State<TiltContainer> createState() => _TiltContainerState();
}

class _TiltContainerState extends State<TiltContainer> {
  late TiltState tiltState;

  /// 是否初始化
  late bool isInit;

  late double width;
  late double height;

  /// 初始坐标区域进度
  late Offset initAreaProgress = widget.initTilt ?? Offset.zero;

  /// 当前坐标区域进度
  late Offset areaProgress = initAreaProgress;

  /// 是否正在移动
  late bool isMove;

  /// 是否禁用光源
  late bool lightDisable = widget.lightConfig.disable ||
      widget.lightConfig.direction == LightDirection.none ||
      widget.lightConfig.intensity == 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tiltState = TiltState.of(context)!;

    isInit = tiltState.isInit;
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
            transform: tiltTransform(width, height, value, widget.angle),
            child: TiltShadow(
              width: width,
              height: height,
              areaProgress: value,
              angle: widget.angle,
              borderRadius: widget.borderRadius,
              clipBehavior: widget.clipBehavior,
              lightConfig: widget.lightConfig,
              shadowConfig: widget.shadowConfig,
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
                      lightConfig: widget.lightConfig,
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
