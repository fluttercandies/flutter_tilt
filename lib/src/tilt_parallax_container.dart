import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/state/tilt_state.dart';

/// 倾斜视差
class TiltParallaxContainer extends StatefulWidget {
  /// 倾斜视差
  ///
  /// 用作视差的 Widget
  ///
  /// 只能在 [Tilt.childInner] 中使用
  const TiltParallaxContainer({
    super.key,
    required this.child,
    required this.size,
    required this.filterQuality,
  });

  final Widget child;

  /// 视差大小 (x, y)
  final Offset size;

  final FilterQuality filterQuality;

  @override
  State<TiltParallaxContainer> createState() => _TiltParallaxContainerState();
}

class _TiltParallaxContainerState extends State<TiltParallaxContainer> {
  late final Offset _size = widget.size;
  late final FilterQuality _filterQuality = widget.filterQuality;

  late TiltState tiltState;

  /// 当前坐标区域进度
  late Offset areaProgress;

  /// 是否正在移动
  late bool isMove;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tiltState = TiltState.of(context)!;

    areaProgress = tiltState.areaProgress;
    isMove = tiltState.isMove;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      duration: Duration(milliseconds: isMove ? 100 : 300),
      tween: Tween<Offset>(end: isMove ? areaProgress : Offset.zero),
      builder: (BuildContext context, Offset value, Widget? child) {
        return Transform(
          filterQuality: _filterQuality,
          transform: Matrix4.identity()
            ..translate(value.dx * _size.dx, value.dy * _size.dy),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
