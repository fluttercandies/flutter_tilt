import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/internal/provider/tilt_animation_provider.dart';

void main() {
  group('TiltAnimationProvider ::', () {
    testWidgets('throws a clear error outside Tilt tree', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            TiltAnimationProvider.of(context);
            return const SizedBox();
          },
        ),
      );

      final exception = tester.takeException();
      expect(exception, isA<FlutterError>());
      expect(
        (exception as FlutterError).message,
        contains(
          'TiltAnimationProvider.of() was called with a context that does not contain a TiltAnimationProvider.',
        ),
      );
    });

    testWidgets('returns the inherited value', (
      WidgetTester tester,
    ) async {
      const animation = AlwaysStoppedAnimation<Offset>(Offset(1, 2));
      late Animation<Offset> resolvedAnimation;

      await tester.pumpWidget(
        TiltAnimationProvider(
          tiltTweenAnimation: animation,
          child: Builder(
            builder: (BuildContext context) {
              resolvedAnimation =
                  TiltAnimationProvider.of(context).tiltTweenAnimation;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolvedAnimation, same(animation));
    });
  });
}
