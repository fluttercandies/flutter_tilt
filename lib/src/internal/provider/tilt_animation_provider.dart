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
    if (tiltAnimationProvider == null) {
      throw FlutterError(
        'TiltAnimationProvider.of() was called with a context that does not contain a TiltAnimationProvider.',
      );
    }
    return tiltAnimationProvider;
  }

  @override
  bool updateShouldNotify(TiltAnimationProvider oldWidget) =>
      tiltTweenAnimation != oldWidget.tiltTweenAnimation;
}
