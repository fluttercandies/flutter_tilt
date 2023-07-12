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
    this.borderRadius,
    required this.sensitivity,
    required this.lightConfig,
    required this.shadowConfig,
  }) : super(key: key);

  final Widget child;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 倾斜灵敏度
  ///
  /// 调整该值后，一般还需要调整 [ShadowConfig.distance] 的值，
  /// 保持一种相对正确的阴影关系
  ///
  /// 为 0 时将会停止不动
  final double sensitivity;

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

  /// 坐标位置
  late Offset position;

  /// 当前坐标的区域进度
  late Offset areaProgress;

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
    position = tiltState.position;
    areaProgress = tiltState.areaProgress;
    isMove = tiltState.isMove;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: isMove ? 100 : 300),
      tween: Tween<Offset>(end: isMove ? areaProgress : Offset.zero),
      builder: (BuildContext context, Offset value, Widget? child) {
        return IgnorePointer(
          child: Transform(
            alignment: AlignmentDirectional.center,
            transform: tiltTransform(width, height, value, widget.sensitivity),
            child: TiltShadow(
              width: width,
              height: height,
              areaProgress: value,
              borderRadius: widget.borderRadius,
              sensitivity: widget.sensitivity,
              lightConfig: widget.lightConfig,
              shadowConfig: widget.shadowConfig,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  /// Body
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: child,
                  ),

                  /// Light
                  if (!lightDisable)
                    TiltLight(
                      width: width,
                      height: height,
                      position: position,
                      areaProgress: value,
                      borderRadius: widget.borderRadius,
                      lightConfig: widget.lightConfig,
                    ),

                  /// Resize
                  ///
                  /// 获取同级的尺寸
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
