import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../config/tilt_light_config.dart';
import '../../config/tilt_shadow_config.dart';
import '../core/tilt_animated_builder.dart';
import '../effects/tilt_light.dart';
import '../effects/tilt_shadow.dart';

class TiltProjectorContainer extends StatelessWidget {
  /// {@template tilt.TiltProjectorContainer.desc.en}
  /// Apply a shadow to the entire [child] and [childLayout], similar to a projector effect.
  /// will display a shadow that exactly matches the non-transparent parts of the widget.
  ///
  /// "Performance risk exists"
  ///
  /// Recommended for the following scenarios:
  /// - Images only
  /// - No data states
  /// - No Hero tags
  ///
  /// You should assess the performance risks yourself.
  /// If your scenario runs smoothly, then you can use it.
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltProjectorContainer.param.en}
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
  /// {@template tilt.TiltProjectorContainer.desc.zh}
  /// 对整个 [child]、[childLayout] 使用类似投影仪效果的阴影，
  /// 会显示与 widget 非透明部分完全一致的阴影。
  ///
  /// “有性能风险”
  ///
  /// 建议在以下场景使用：
  /// - 仅图片
  /// - 无数据状态
  /// - 无 Hero 标签
  ///
  /// 你应该自行评估性能风险，
  /// 如果你应用的场景运行流畅，则可继续使用。
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltProjectorContainer.param.zh}
  /// - [child]：主要 child，倾斜和效果将应用于此 widget。
  /// - [childLayout]：其他 child 布局。例如：位于 child 内部、外部、后面的视差布局 [TiltParallax]。
  /// - [lightConfig]：光照效果配置。
  /// - [shadowConfig]：阴影效果配置。
  /// - [border]：BoxDecoration 边框样式。
  /// - [borderRadius]：BoxDecoration 边框圆角半径。
  /// - [clipBehavior]：容器的裁剪表现。
  /// - [filterQuality]：Transform 的质量。
  /// {@endtemplate}
  const TiltProjectorContainer({
    super.key,
    required this.child,
    this.childLayout = const ChildLayout(),
    @Deprecated(
      '\nThe current simulated light effect is not suitable for Projector, '
      'This feature was deprecated after v4.0.0.\n'
      '------\n'
      '当前的模拟光照效果对 Projector 并不合适。此功能在 v4.0.0 版本后已弃用。\n',
    )
    this.lightConfig = const LightProjectorConfig(),
    this.shadowConfig = const ShadowProjectorConfig(),
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
  ///
  final ChildLayout childLayout;

  /// Light effect config.
  ///
  /// ------
  ///
  /// 光照效果配置。
  @Deprecated(
    '\nThe current simulated light effect is not suitable for Projector, '
    'This feature was deprecated after v4.0.0.\n'
    '------\n'
    '当前的模拟光照效果对 Projector 并不合适。此功能在 v4.0.0 版本后已弃用。\n',
  )
  final LightProjectorConfig lightConfig;

  /// Shadow effect config.
  ///
  /// ------
  ///
  /// 阴影效果配置。
  final ShadowProjectorConfig shadowConfig;

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
      builder: (context, tiltAnimatedState, child) {
        final animatedTiltData = tiltAnimatedState.animatedTiltData;

        return Transform(
          alignment: AlignmentDirectional.center,
          filterQuality: filterQuality,
          transform: animatedTiltData.transform,
          child: Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: _buildChildren(
              child: child,
              width: animatedTiltData.width,
              height: animatedTiltData.height,
              areaProgress: animatedTiltData.areaProgress,
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
      /// shadow
      TiltShadowProjector(
        width: width,
        height: height,
        areaProgress: areaProgress,
        lightConfig: lightConfig,
        shadowConfig: shadowConfig,
        child: Stack(
          alignment: AlignmentDirectional.center,
          clipBehavior: Clip.none,
          children: [
            /// behind child
            ...childLayout.behind,

            /// main child
            Container(
              decoration: BoxDecoration(
                border: border,
                borderRadius: borderRadius,
              ),
              clipBehavior: clipBehavior,
              child: _buildStackInner(
                clipBehavior: clipBehavior,
                children: <Widget>[
                  /// body
                  child ?? const SizedBox(),

                  /// inner child
                  ...childLayout.inner,
                ],
              ),
            ),

            /// outer child
            ...childLayout.outer,
          ],
        ),
      ),

      /// behind child
      ...childLayout.behind,

      /// main child
      Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
        ),
        clipBehavior: clipBehavior,
        child: _buildStackInner(
          clipBehavior: clipBehavior,
          children: <Widget>[
            /// body
            child ?? const SizedBox(),

            /// inner child
            ...childLayout.inner,

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

      /// TODO: 即将弃用，不适合 Projector 效果，4.1.0 版本将移除
      if (!lightConfig.disable)
        IgnorePointer(
          child: Transform.scale(
            scale: lightConfig.projectorScale,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
              ),
              clipBehavior: clipBehavior,
              child: _buildStackInner(
                clipBehavior: clipBehavior,
                children: <Widget>[
                  TiltLight(
                    width: width,
                    height: height,
                    areaProgress: areaProgress,
                    lightConfig: lightConfig,
                  ),
                ],
              ),
            ),
          ),
        ),
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
