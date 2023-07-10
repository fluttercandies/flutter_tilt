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
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.borderRadius,
    required this.sensitivity,
    required this.lightConfig,
    required this.shadowConfig,
  });

  final double width;
  final double height;
  final Widget child;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// 倾斜灵敏度
  ///
  /// 调整该值后，一般还需要调整 [shadowDistance] 的值，
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
  late double width = widget.width;
  late double height = widget.height;

  /// 初始的坐标
  late Offset initPosition = centerPosition(width, height);

  /// 坐标位置
  late Offset position;

  /// 是否正在移动
  late bool isMove;

  /// 是否有光源
  late bool isLight = widget.lightConfig.direction != LightDirection.none ||
      widget.lightConfig.intensity == 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final TiltState tiltState = TiltState.of(context)!;
    position = tiltState.position;
    isMove = tiltState.isMove;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: isMove ? 100 : 300),
      tween: Tween<Offset>(
        begin: isMove ? Offset.zero : position,
        end: isMove ? position : initPosition,
      ),
      builder: (context, value, child) {
        position = value;

        return IgnorePointer(
          child: Transform(
            alignment: Alignment.center,
            transform: tiltTransform(width, height, value, widget.sensitivity),

            /// Shadow
            child: TiltShadow(
              width: width,
              height: height,
              position: value,
              borderRadius: widget.borderRadius,
              sensitivity: widget.sensitivity,
              shadowConfig: widget.shadowConfig,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  /// Body
                  Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: child,
                  ),

                  /// Light
                  if (isLight)
                    TiltLight(
                      width: width,
                      height: height,
                      position: value,
                      borderRadius: widget.borderRadius,
                      lightConfig: widget.lightConfig,
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
