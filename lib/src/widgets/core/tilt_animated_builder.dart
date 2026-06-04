import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../enums.dart';
import '../../internal/provider/tilt_animation_provider.dart';
import '../../internal/provider/tilt_provider.dart';
import '../../internal/tilt_state.dart';
import '../../models/tilt_data_model.dart';
import '../../utils/utils.dart';

/// {@template tilt.TiltAnimatedWidgetBuilder.en}
/// A builder callback for [TiltAnimatedBuilder] that is called on every animation frame.
///
/// - [context]: The build context.
/// - [tiltAnimatedState]: The current animation snapshot containing the animated tilt data and target tilt data.
/// - [child]: The pre-built subtree passed to [TiltAnimatedBuilder.child], or `null`.
/// {@endtemplate}
///
/// ------
///
/// {@template tilt.TiltAnimatedWidgetBuilder.zh}
/// [TiltAnimatedBuilder] 的 builder 回调，每帧动画更新时触发。
///
/// - [context]：当前 build context。
/// - [tiltAnimatedState]：当前动画快照，包含动画倾斜数据和目标倾斜数据。
/// - [child]：传入 [TiltAnimatedBuilder.child] 的预构建子树，可能为 `null`。
/// {@endtemplate}
typedef TiltAnimatedWidgetBuilder = Widget Function(
  BuildContext context,
  TiltAnimatedState tiltAnimatedState,
  Widget? child,
);

@immutable
class TiltAnimatedState {
  const TiltAnimatedState({
    required this.tiltConfig,
    required this.animatedTiltData,
    required this.targetTiltData,
    required this.currentGesturesType,
    required this.isCurrentGesturesTypeActive,
  });

  /// The current tilt configuration.
  ///
  /// ------
  ///
  /// 当前倾斜配置。
  final TiltConfig tiltConfig;

  /// The current animated tilt data,
  /// which represents the interpolated result from the initial state to [targetTiltData]
  /// and is used for rendering the current animation progress.
  ///
  /// During the animation, [animatedTiltData] will gradually change from the initial state and approach [targetTiltData].
  ///
  /// ------
  ///
  /// 当前动画倾斜数据，
  /// 表示从初始状态到 [targetTiltData] 的插值结果，用于渲染当前动画进度。
  ///
  /// 动画过程中 [animatedTiltData] 会逐渐从初始状态变化并趋近于 [targetTiltData]。
  final TiltDataModel animatedTiltData;

  /// The current target tilt data,
  /// which is the final target data of the animation.
  ///
  /// During the animation, [animatedTiltData] will gradually change from the initial state and approach [targetTiltData].
  ///
  /// ------
  ///
  /// 当前目标倾斜数据，动画最终的目标数据。
  ///
  /// 动画过程中 [animatedTiltData] 会逐渐从初始状态变化并趋近于 [targetTiltData]。
  final TiltDataModel targetTiltData;

  /// The current gestures type.
  ///
  /// ------
  ///
  /// 当前手势类型。
  final GesturesType currentGesturesType;

  /// {@macro tilt.TiltStreamModel.isActive.en}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltStreamModel.isActive.zh}。
  final bool isCurrentGesturesTypeActive;
}

/// TiltAnimatedBuilder
class TiltAnimatedBuilder extends StatelessWidget {
  /// It can only be used inside the Tilt widget tree.
  ///
  /// It provides a customizable animation [builder] callback for rendering logic.
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
  ///     builder: (context, tiltAnimatedState, child) {
  ///       final animatedTiltData = tiltAnimatedState.animatedTiltData;
  ///       final tiltTransform = animatedTiltData.transform;
  ///       final areaProgress = animatedTiltData.areaProgress;
  ///
  ///       return RepaintBoundary(
  ///         child: Transform(
  ///           alignment: AlignmentDirectional.center,
  ///           transform: tiltTransform,
  ///           child: MyCustomWidget(
  ///             progress: areaProgress,
  ///             child: child, // SomeWidget()
  ///           ),
  ///         ),
  ///       );
  ///     },
  ///     child: SomeWidget(),
  ///   ),
  /// ),
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
    final tiltState = TiltProvider.of(context);
    final tiltAnimationProvider = TiltAnimationProvider.of(context);
    final tiltTweenAnimation = tiltAnimationProvider.tiltTweenAnimation;
    final targetTiltData = tiltState.toModel();

    return AnimatedBuilder(
      animation: tiltTweenAnimation,
      builder: (BuildContext context, Widget? child) {
        final tiltAnimatedState = TiltAnimatedState(
          tiltConfig: tiltState.tiltConfig,
          animatedTiltData: _animatedTiltDataModel(
            tiltState,
            tiltTweenAnimation.value,
          ),
          targetTiltData: targetTiltData,
          currentGesturesType: tiltState.currentGesturesType,
          isCurrentGesturesTypeActive: tiltState.isActive,
        );

        return builder(context, tiltAnimatedState, child);
      },
      child: child,
    );
  }

  TiltDataModel _animatedTiltDataModel(
    TiltState tiltState,
    Offset animatedAreaProgress,
  ) {
    return TiltDataModel(
      width: tiltState.width,
      height: tiltState.height,
      position: Utils.progressPosition(
        tiltState.width,
        tiltState.height,
        animatedAreaProgress,
      ),
      transform: tiltState.isInit && !tiltState.disable
          ? tiltState.tiltTransformFor(animatedAreaProgress)
          : Matrix4.identity(),
      areaProgress: animatedAreaProgress,
      angle: Utils.rotateAxis(
        animatedAreaProgress * tiltState.tiltConfig.angle,
        tiltState.tiltConfig.enableReverse,
      ),
    );
  }
}
