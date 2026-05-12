import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/internal/provider/tilt_provider.dart';

void main() {
  group('TiltProvider ::', () {
    testWidgets('throws a clear error outside Tilt tree', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            TiltProvider.of(context);
            return const SizedBox();
          },
        ),
      );

      final exception = tester.takeException();
      expect(exception, isA<FlutterError>());
      expect(
        (exception as FlutterError).message,
        contains(
          'TiltProvider.of() was called with a context that does not contain a TiltProvider.',
        ),
      );
    });
  });
}
