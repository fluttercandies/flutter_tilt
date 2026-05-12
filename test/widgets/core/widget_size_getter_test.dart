import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/widgets/core/widget_size_getter.dart';

void main() {
  group('WidgetSizeGetter ::', () {
    testWidgets('reports initial size and descendant layout changes', (
      WidgetTester tester,
    ) async {
      final reportedSizes = <Size>[];
      final widthNotifier = ValueNotifier<double>(10.0);

      await tester.pumpWidget(
        Center(
          child: WidgetSizeGetter(
            onSize: reportedSizes.add,
            child: ValueListenableBuilder<double>(
              valueListenable: widthNotifier,
              builder: (context, width, _) {
                return SizedBox(width: width, height: 20.0);
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(reportedSizes.last, const Size(10.0, 20.0));

      widthNotifier.value = 40.0;
      await tester.pump();

      expect(reportedSizes.last, const Size(40.0, 20.0));
    });
  });
}
