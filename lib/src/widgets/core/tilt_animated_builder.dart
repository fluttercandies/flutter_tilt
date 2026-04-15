import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../internal/provider/tilt_animation_provider.dart';
import '../../internal/provider/tilt_provider.dart';
import '../../internal/tilt_data.dart';
import '../../models/tilt_data_model.dart';

/// {@template tilt.TiltAnimatedWidgetBuilder.en}
/// A builder callback for [TiltAnimatedBuilder] that is called on every animation frame.
///
/// - [context]: The build context.
/// - [tiltData]: The current tilt data snapshot, updated on every animation tick.
/// - [tiltConfig]: The current tilt configuration.
/// - [child]: The pre-built subtree passed to [TiltAnimatedBuilder.child], or `null`.
/// {@endtemplate}
///
/// ------
///
/// {@template tilt.TiltAnimatedWidgetBuilder.zh}
/// [TiltAnimatedBuilder] 的 builder 回调，每帧动画更新时触发。
///
/// - [context]：当前 build context。
/// - [tiltData]：当前帧的倾斜数据快照，每帧动画更新时变化。
/// - [tiltConfig]：当前的倾斜配置。
/// - [child]：传入 [TiltAnimatedBuilder.child] 的预构建子树，可能为 `null`。
/// {@endtemplate}
typedef TiltAnimatedWidgetBuilder = Widget Function(
  BuildContext context,
  TiltDataModel tiltData,
  TiltConfig tiltConfig,
  Widget? child,
);

/// TiltAnimatedBuilder
class TiltAnimatedBuilder extends StatelessWidget {
  /// It can only be used inside the Tilt widget tree.
  ///
  /// It provides a customisable animation [builder] callback for rendering logic.
  /// (for example, [Transform]).
  ///
  /// ------
  ///
  /// 只能在 [Tilt] widget 树内使用。
  ///
  /// 提供可自定义动画的 [builder] 回调，
  /// 用于实现自定义渲染逻辑（例如 [Transform]）。
  ///
  /// ------
  ///
  /// Example:
  ///
  /// ```dart
  /// Tilt(
  ///   child: TiltAnimatedBuilder(
  ///     builder: (context, tiltData, tiltConfig, child) {
  ///       return Transform(
  ///         alignment: AlignmentDirectional.center,
  ///         transform: tiltData.transform,
  ///         child: MyCustomWidget(progress: tiltData.areaProgress, child: child),
  ///       );
  ///     },
  ///     child: SomeWidget(),
  ///   ),
  /// )
  /// ```
  ///
  const TiltAnimatedBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  /// [TiltAnimatedWidgetBuilder]
  ///
  /// Called every time the Tilt animation changes.
  ///
  /// The child passed to this builder should typically be included in the returned widget tree.
  ///
  /// {@macro tilt.TiltAnimatedWidgetBuilder.en}
  ///
  /// ------
  ///
  /// 当 Tilt 动画变化时会触发此回调。
  ///
  /// 传入该 builder 的 child 通常应包含在最终返回的 widget 树中。
  ///
  /// {@macro tilt.TiltAnimatedWidgetBuilder.zh}
  ///
  final TiltAnimatedWidgetBuilder builder;

  /// The child widget passed to the [builder].
  ///
  /// If part of the builder subtree does not depend on Tilt animation changes,
  /// prebuild it as child to avoid rebuilding it on every animation update.
  ///
  /// Using child is optional,
  /// but it can significantly improve performance in suitable cases and is a recommended practice.
  ///
  /// ------
  ///
  /// 用于传给 [builder] 的 child widget。
  ///
  /// 当 builder 中有一部分子树不依赖 Tilt 动画变化时，
  /// 建议通过预构建 child 传入，避免每次动画更新都重复构建该部分。
  ///
  /// child 参数是可选的，
  /// 但在合适场景下能显著提升性能，属于推荐的做法。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tiltProvider = TiltProvider.of(context);
    final tiltAnimationProvider = TiltAnimationProvider.of(context);
    final tiltTweenAnimation = tiltAnimationProvider.tiltTweenAnimation;
    final tiltConfig = tiltProvider.tiltConfig;

    return AnimatedBuilder(
      animation: tiltTweenAnimation,
      builder: (BuildContext context, Widget? child) {
        final areaProgress = tiltTweenAnimation.value;
        final tiltData = TiltData(
          isInit: tiltProvider.isInit,
          width: tiltProvider.width,
          height: tiltProvider.height,
          areaProgress: areaProgress,
          tiltConfig: tiltConfig,
        ).toModel();
        return builder(context, tiltData, tiltConfig, child);
      },
      child: child,
    );
  }
}
