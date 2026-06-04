import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// 统计自身 [RenderObject.paint] 被调用次数的测试辅助 widget
///
/// 用于验证 [RepaintBoundary] 的隔离效果：
/// - 放在边界 **外**（父）的计数器，在边界内部重绘时**不应**增加
/// - 放在边界 **内** (子) 的计数器，则**应**随动画重绘而增加
///
/// 它本身不是 repaint boundary，因此其 [paint] 是否被调用，
/// 直接反映了它所在的子树这一帧是否被重绘。
class PaintCounter extends SingleChildRenderObjectWidget {
  const PaintCounter({
    super.key,
    required this.onPaint,
    required Widget super.child,
  });

  /// 每次 [paint] 调用时触发
  final VoidCallback onPaint;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderPaintCounter(onPaint);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderPaintCounter renderObject,
  ) {
    renderObject.onPaint = onPaint;
  }
}

class RenderPaintCounter extends RenderProxyBox {
  RenderPaintCounter(this.onPaint);

  VoidCallback onPaint;

  @override
  void paint(PaintingContext context, Offset offset) {
    onPaint();
    super.paint(context, offset);
  }
}
