import 'package:flutter/widgets.dart';

import '../tilt_state.dart';

/// Tilt Base Provider
class TiltProvider extends InheritedWidget {
  /// Tilt Base Provider
  const TiltProvider({
    super.key,
    required super.child,
    required this.data,
  });

  final TiltState data;

  static TiltState of(BuildContext context) {
    final tiltProvider =
        context.dependOnInheritedWidgetOfExactType<TiltProvider>();
    assert(tiltProvider != null, 'No TiltProvider found in context');
    return tiltProvider!.data;
  }

  @override
  bool updateShouldNotify(TiltProvider oldWidget) => data != oldWidget.data;
}
