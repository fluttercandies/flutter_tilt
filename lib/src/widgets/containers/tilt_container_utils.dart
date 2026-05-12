import 'package:flutter/widgets.dart';
import '../core/widget_size_getter.dart';

abstract final class TiltContainerUtils {
  /// TODO: 已被 [WidgetSizeGetter] 替代，后续删除
  ///
  /// 尺寸监听 Widget
  ///
  /// - [onResize] 调整尺寸回调
  static Widget buildWidgetResize(void Function(Size) onResize) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            onResize(constraints.biggest);
          }
        });
        return const SizedBox();
      },
    );
  }
}
