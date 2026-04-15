import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'shared_widgets/tilt_widget.dart';

void main() {
  final childFinder = find.text('Tilt');

  group('Tilt.projector ::', () {
    testWidgets('default', (WidgetTester tester) async {
      await tester.pumpWidget(const TiltProjectorWidget());
      await tester.pumpAndSettle();
      expect(childFinder, findsNWidgets(2));
    });

    testWidgets('ChildLayout UI layer order', (WidgetTester tester) async {
      const outerKey = Key('outer');
      const innerKey = Key('inner');
      const childKey = Key('child');
      const behindKey = Key('behind');
      const layerOrder = [outerKey, innerKey, childKey, behindKey];

      Widget buildTestWidget() {
        return const TiltProjectorWidget(
          childLayout: ChildLayout(
            outer: [Text('outer', key: outerKey)],
            inner: [Text('inner', key: innerKey)],
            behind: [Text('behind', key: behindKey)],
          ),
        );
      }

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      final allTextKeys = tester
          .widgetList<Text>(find.byType(Text))
          .map((value) => value.key)
          .toList()
          .reversed;
      expect(allTextKeys, [
        ...layerOrder,

        /// 投影层
        ...layerOrder,
      ]);
    });
  });
}
