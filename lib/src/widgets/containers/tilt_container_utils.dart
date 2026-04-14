import 'package:flutter/widgets.dart';

abstract final class TiltContainerUtils {
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
