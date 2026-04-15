import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../config/tilt_light_config.dart';
import '../../config/tilt_shadow_config.dart';
import '../core/tilt_animated_builder.dart';
import '../effects/tilt_light.dart';
import '../effects/tilt_shadow.dart';

class TiltBaseContainer extends StatelessWidget {
  /// {@template tilt.TiltBaseContainer.desc.en}
  /// A base container widget that provides tilt and simulated light and shadow effects.
  ///
  /// Use normal shadow effects only for [child].
  /// {@endtemplate}
  ///
  /// {@template tilt.TiltBaseContainer.param.en}
  /// - [child]: The main child widget to which tilt and effects are applied.
  /// - [childLayout]: Other child layouts. e.g. [TiltParallax] parallax inner, outer, behind.
  /// - [lightConfig]: Light effect config.
  /// - [shadowConfig]: Shadow effect config.
  /// - [border]: BoxDecoration border.
  /// - [borderRadius]: BoxDecoration borderRadius.
  /// - [clipBehavior]: Clip behavior for the container.
  /// - [filterQuality]: Filter quality for the transform.
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltBaseContainer.desc.zh}
  /// 基础容器 widget 包含倾斜、模拟光影效果。
  ///
  /// 仅对 [child] 使用普通阴影效果。
  /// {@endtemplate}
  ///
  /// {@template tilt.TiltBaseContainer.param.zh}
  /// - [child]：主要 child，倾斜和效果将应用于此 widget。
  /// - [childLayout]：其他 child 布局。例如：位于 child 内部、外部、后面的视差布局 [TiltParallax]。
  /// - [lightConfig]：光照效果配置。
  /// - [shadowConfig]：阴影效果配置。
  /// - [border]：BoxDecoration 边框样式。
  /// - [borderRadius]：BoxDecoration 边框圆角半径。
  /// - [clipBehavior]：容器的裁剪行为。
  /// - [filterQuality]：Transform 的滤镜质量。
  /// {@endtemplate}
  const TiltBaseContainer({
    super.key,
    required this.child,
    this.childLayout = const ChildLayout(),
    this.lightConfig = const LightConfig(),
    this.shadowConfig = const ShadowBaseConfig(),
    this.border,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.filterQuality,
  });

  final Widget child;

  /// Other child layouts. e.g. [TiltParallax] parallax inner, outer, behind.
  ///
  /// ------
  ///
  /// 其他 child 布局。例如：位于 child 内部、外部、后面的视差布局 [TiltParallax]。
  final ChildLayout childLayout;

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
  final ShadowBaseConfig shadowConfig;

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

  /// Transform filter quality.
  final FilterQuality? filterQuality;

  @override
  Widget build(BuildContext context) {
    return TiltAnimatedBuilder(
      builder: (context, tiltData, tiltConfig, child) {
        return Transform(
          alignment: AlignmentDirectional.center,
          filterQuality: filterQuality,
          transform: tiltData.transform,
          child: Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: _buildChildren(
              child: child,
              width: tiltData.width,
              height: tiltData.height,
              areaProgress: tiltData.areaProgress,
            ),
          ),
        );
      },
      child: child,
    );
  }

  List<Widget> _buildChildren({
    Widget? child,
    required double width,
    required double height,
    required Offset areaProgress,
  }) {
    return [
      /// behind child
      ...childLayout.behind,

      /// main child
      TiltShadowBase(
        width: width,
        height: height,
        areaProgress: areaProgress,
        border: border,
        borderRadius: borderRadius,
        clipBehavior: clipBehavior,
        lightConfig: lightConfig,
        shadowConfig: shadowConfig,
        child: _buildStackInner(
          clipBehavior: clipBehavior,
          children: <Widget>[
            /// body
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
              ),
              clipBehavior: clipBehavior,
              child: child,
            ),

            /// inner child
            ...childLayout.inner,

            /// light
            TiltLight(
              width: width,
              height: height,
              areaProgress: areaProgress,
              lightConfig: lightConfig,
            ),

            /// TODO: 已被 [WidgetSizeGetter] 替代，后续删除
            /// resize
            // Positioned.fill(
            //   child: TiltContainerUtils.buildWidgetResize(onResize),
            // ),
          ],
        ),
      ),

      /// outer child
      ...childLayout.outer,
    ];
  }

  /// 构建内部 Stack
  ///
  /// - [clipBehavior] 裁剪行为
  /// - [children] 子组件列表
  Widget _buildStackInner({
    required Clip clipBehavior,
    required List<Widget> children,
  }) {
    return Stack(
      alignment: AlignmentDirectional.center,

      /// 避免暴露其他组件，[Clip.none] 时，默认赋值 [Clip.hardEdge]
      clipBehavior: clipBehavior == Clip.none ? Clip.hardEdge : clipBehavior,
      children: children,
    );
  }
}
