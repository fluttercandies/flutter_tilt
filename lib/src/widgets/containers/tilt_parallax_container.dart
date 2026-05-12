import 'package:flutter/widgets.dart';

import '../core/tilt_animated_builder.dart';

class TiltParallaxContainer extends StatelessWidget {
  /// {@template tilt.TiltParallaxContainer.desc.en}
  /// A parallax effect widget that can only be used inside [Tilt].
  ///
  /// Create a parallax layer within the Tilt widget tree.
  /// {@endtemplate}
  ///
  /// {@template tilt.TiltParallaxContainer.param.en}
  /// - [offset]: Parallax offset.
  /// - [filterQuality]: Flutter FilterQuality.
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltParallaxContainer.desc.zh}
  /// 倾斜视差，只能在 [Tilt] 中使用的视差效果 widget。
  ///
  /// 在 Tilt widget 树内创建视差效果层。
  /// {@endtemplate}
  ///
  /// {@template tilt.TiltParallaxContainer.param.zh}
  /// - [offset]：视差偏移量。
  /// - [filterQuality]：Flutter FilterQuality。
  /// {@endtemplate}
  const TiltParallaxContainer({
    super.key,
    required this.child,
    required this.offset,
    this.filterQuality,
  });

  final Widget child;

  /// Parallax offset
  ///
  /// ------
  ///
  /// 视差偏移量 (x, y)
  final Offset offset;

  final FilterQuality? filterQuality;

  @override
  Widget build(BuildContext context) {
    return TiltAnimatedBuilder(
      builder: (context, tiltAnimatedState, child) {
        final tiltParallaxTransform = this.tiltParallaxTransform(
          tiltAnimatedState.animatedTiltData.areaProgress,
          offset,
          tiltAnimatedState.tiltConfig.enableReverse,
        );

        return Transform(
          filterQuality: filterQuality,
          transform: tiltParallaxTransform,
          child: child,
        );
      },
      child: child,
    );
  }

  /// 计算当前倾斜视差
  ///
  /// - [areaProgress] 当前坐标的区域进度
  /// - [offset] 视差偏移量
  /// - [enableReverse] 开启倾斜反向，向上或向下倾斜
  Matrix4 tiltParallaxTransform(
    Offset areaProgress,
    Offset offset,
    bool enableReverse,
  ) {
    final dx = offset.dx * areaProgress.dx;
    final dy = offset.dy * areaProgress.dy;
    final parallaxOffset = enableReverse ? Offset(-dx, -dy) : Offset(dx, dy);
    // TODO: 兼容低版本开发者，未来完全弃用时再替换为新的方法（Flutter 3.35 开始标记为弃用）
    // ignore: deprecated_member_use
    return Matrix4.identity()..translate(parallaxOffset.dx, parallaxOffset.dy);
  }
}
