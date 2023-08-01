import 'package:flutter_test/flutter_test.dart';
import 'tilt_widget.dart';

void main() {
  testWidgets('tilt default', (WidgetTester tester) async {
    await tester.pumpWidget(const TiltWidget());
    final Finder childFinder = find.text('Tilt');
    expect(childFinder, findsOneWidget);
  });
}
