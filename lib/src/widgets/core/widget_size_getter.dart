import 'package:flutter/widgets.dart';

/// WidgetSizeGetter
class WidgetSizeGetter extends StatefulWidget {
  /// Measures the actual layout size of [child] and reports updates via [onSize].
  ///
  /// It reports the initial size after the first frame,
  /// and keeps listening for subsequent size changes.
  ///
  /// ------
  ///
  /// 获取 [child] 的实际布局尺寸，并通过 [onSize] 回调上报。
  ///
  /// 会在首帧布局完成后上报初始尺寸，
  /// 并在后续尺寸变化时持续监听和上报。
  const WidgetSizeGetter({
    super.key,
    required this.child,
    required this.onSize,
  });

  /// The widget whose layout size will be measured.
  ///
  /// ------
  ///
  /// 需要测量实际布局尺寸的 child widget。
  final Widget child;

  /// Called when the actual layout size changes.
  ///
  /// ------
  ///
  /// 当实际布局尺寸发生变化时触发的回调。
  final void Function(Size size) onSize;

  @override
  State<WidgetSizeGetter> createState() => _WidgetSizeGetterState();
}

class _WidgetSizeGetterState extends State<WidgetSizeGetter> {
  final _globalKey = GlobalKey();
  Size? _lastSize;

  @override
  void initState() {
    super.initState();
    _scheduleNotifySize();
  }

  void _scheduleNotifySize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _notifySize();
      }
    });
  }

  void _notifySize() {
    final context = _globalKey.currentContext;
    if (context != null && context.mounted) {
      final size = context.size;
      if (size != null && size != _lastSize) {
        _lastSize = size;
        widget.onSize(size);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        _scheduleNotifySize();
        return false;
      },
      child: SizeChangedLayoutNotifier(key: _globalKey, child: widget.child),
    );
  }
}
