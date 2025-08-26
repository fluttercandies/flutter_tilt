import 'package:flutter/widgets.dart';

import '../internal/mixin/tilt_tween_animation_mixin.dart';
import '../internal/tilt_state.dart';

/// 倾斜视差
class TiltParallaxContainer extends StatefulWidget {
  /// 倾斜视差
  ///
  /// 用作视差的 Widget
  ///
  /// 只能在 [Tilt.childLayout] 中使用
  const TiltParallaxContainer({
    super.key,
    required this.child,
    required this.size,
    this.filterQuality,
  });

  final Widget child;

  /// 视差大小 (x, y)
  final Offset size;

  final FilterQuality? filterQuality;

  @override
  State<TiltParallaxContainer> createState() => _TiltParallaxContainerState();
}

class _TiltParallaxContainerState extends State<TiltParallaxContainer>
    with TickerProviderStateMixin, TiltTweenAnimationMixin {
  @override
  Widget build(BuildContext context) {
    final tiltState = TiltState.of(context);

    return AnimatedBuilder(
      animation: tiltTweenAnimation,
      builder: (BuildContext context, Widget? child) {
        final areaProgress = tiltTweenAnimation.value;

        return Transform(
          filterQuality: widget.filterQuality,
          transform: tiltParallaxTransform(
            areaProgress,
            widget.size,
            tiltState.tiltConfig.enableReverse,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  /// 计算当前倾斜视差
  ///
  /// - [areaProgress] 当前坐标的区域进度
  /// - [size] 视差大小
  /// - [enableReverse] 开启倾斜反向，向上或向下倾斜
  Matrix4 tiltParallaxTransform(
    Offset areaProgress,
    Offset size,
    bool enableReverse,
  ) {
    final dx = size.dx * areaProgress.dx;
    final dy = size.dy * areaProgress.dy;
    final offset = enableReverse ? Offset(-dx, -dy) : Offset(dx, dy);
    // TODO: 兼容低版本开发者，未来完全弃用时再替换为新的方法（Flutter 3.35 开始标记为弃用）
    // ignore: deprecated_member_use
    return Matrix4.identity()..translate(offset.dx, offset.dy);
  }
}
