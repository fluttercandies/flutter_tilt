/// Path: flutter\lib\src\widgets\basic.dart
///
/// Widget: Listener
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A widget that calls callbacks in response to common pointer events.
///
/// It listens to events that can construct gestures, such as when the
/// pointer is pressed, moved, then released or canceled.
///
/// It does not listen to events that are exclusive to mouse, such as when the
/// mouse enters, exits or hovers a region without pressing any buttons. For
/// these events, use [MouseRegion].
///
/// Rather than listening for raw pointer events, consider listening for
/// higher-level gestures using [GestureDetector].
///
/// ## Layout behavior
///
/// _See [BoxConstraints] for an introduction to box layout models._
///
/// If it has a child, this widget defers to the child for sizing behavior. If
/// it does not have a child, it grows to fit the parent instead.
///
/// {@tool dartpad}
/// This example makes a [Container] react to being touched, showing a count of
/// the number of pointer downs and ups.
///
/// ** See code in examples/api/lib/widgets/basic/listener.0.dart **
/// {@end-tool}
class TiltTouchListener extends SingleChildRenderObjectWidget {
  /// Creates a widget that forwards point events to callbacks.
  ///
  /// The [behavior] argument defaults to [HitTestBehavior.translucent].
  const TiltTouchListener({
    Key? key,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    this.onPointerHover,
    this.onPointerCancel,
    this.onPointerSignal,

    /// Change the default to translucent
    this.behavior = HitTestBehavior.translucent,
    Widget? child,
  }) : super(key: key, child: child);

  /// Called when a pointer comes into contact with the screen (for touch
  /// pointers), or has its button pressed (for mouse pointers) at this widget's
  /// location.
  final PointerDownEventListener? onPointerDown;

  /// Called when a pointer that triggered an [onPointerDown] changes position.
  final PointerMoveEventListener? onPointerMove;

  /// Called when a pointer that triggered an [onPointerDown] is no longer in
  /// contact with the screen.
  final PointerUpEventListener? onPointerUp;

  /// Called when a pointer that has not triggered an [onPointerDown] changes
  /// position.
  ///
  /// This is only fired for pointers which report their location when not down
  /// (e.g. mouse pointers, but not most touch pointers).
  final PointerHoverEventListener? onPointerHover;

  /// Called when the input from a pointer that triggered an [onPointerDown] is
  /// no longer directed towards this receiver.
  final PointerCancelEventListener? onPointerCancel;

  /// Called when a pointer signal occurs over this object.
  ///
  /// See also:
  ///
  ///  * [PointerSignalEvent], which goes into more detail on pointer signal
  ///    events.
  final PointerSignalEventListener? onPointerSignal;

  /// How to behave during hit testing.
  final HitTestBehavior behavior;

  @override
  RenderPointerListener createRenderObject(BuildContext context) {
    return RenderPointerListener(
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
      onPointerHover: onPointerHover,
      onPointerCancel: onPointerCancel,
      onPointerSignal: onPointerSignal,
      behavior: behavior,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderPointerListener renderObject) {
    renderObject
      ..onPointerDown = onPointerDown
      ..onPointerMove = onPointerMove
      ..onPointerUp = onPointerUp
      ..onPointerHover = onPointerHover
      ..onPointerCancel = onPointerCancel
      ..onPointerSignal = onPointerSignal
      ..behavior = behavior;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final List<String> listeners = <String>[
      if (onPointerDown != null) 'down',
      if (onPointerMove != null) 'move',
      if (onPointerUp != null) 'up',
      if (onPointerHover != null) 'hover',
      if (onPointerCancel != null) 'cancel',
      if (onPointerSignal != null) 'signal',
    ];
    properties.add(
        IterableProperty<String>('listeners', listeners, ifEmpty: '<none>'));
    properties.add(EnumProperty<HitTestBehavior>('behavior', behavior));
  }
}
