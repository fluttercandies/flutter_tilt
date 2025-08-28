import 'package:flutter/widgets.dart';

class TiltAnimationProvider extends InheritedWidget {
  const TiltAnimationProvider({
    super.key,
    required super.child,
    required this.tiltTweenAnimation,
  });

  /// [TiltTweenAnimationMixin.tiltTweenAnimation]
  final Animation<Offset> tiltTweenAnimation;

  static TiltAnimationProvider of(BuildContext context) {
    final tiltAnimationProvider =
        context.dependOnInheritedWidgetOfExactType<TiltAnimationProvider>();
    assert(
      tiltAnimationProvider != null,
      'No TiltAnimationProvider found in context',
    );
    return tiltAnimationProvider!;
  }

  @override
  bool updateShouldNotify(TiltAnimationProvider oldWidget) =>
      tiltTweenAnimation != oldWidget.tiltTweenAnimation;
}
