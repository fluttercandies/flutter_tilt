import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_config.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/internal/action_input/tilt_action_input_resolver.dart';
import 'package:flutter_tilt/src/models/tilt_stream_model.dart';

void main() {
  group('TiltActionInputResolver ::', () {
    late TiltActionInputResolver resolver;

    setUp(() {
      resolver = TiltActionInputResolver(
        initialTiltStreamModel: const TiltStreamModel(
          position: Offset(10, 10),
          gesturesType: GesturesType.none,
          isActive: false,
        ),
        tiltConfig: const TiltConfig(
          leaveDuration: Duration(milliseconds: 10),
          controllerLeaveDuration: Duration(milliseconds: 15),
        ),
      );
    });

    tearDown(() {
      resolver.dispose();
    });

    test('keeps higher priority input active over sensors', () {
      resolver.resolve(
        const TiltStreamModel(
          position: Offset(1, 1),
          gesturesType: GesturesType.controller,
        ),
        deviceOrientation: DeviceOrientation.portraitUp,
      );

      final result = resolver.resolve(
        const TiltStreamModel(
          position: Offset(2, 2),
          gesturesType: GesturesType.sensors,
        ),
        deviceOrientation: DeviceOrientation.portraitUp,
      );

      expect(result.gesturesType, GesturesType.controller);
      expect(result.position, const Offset(1, 1));
    });

    test('allows sensors again after gesture leave conflict window', () async {
      resolver.resolve(
        const TiltStreamModel(
          position: Offset(3, 3),
          gesturesType: GesturesType.touch,
          isActive: true,
        ),
        deviceOrientation: DeviceOrientation.portraitUp,
      );

      resolver.resolve(
        const TiltStreamModel(
          position: Offset(3, 3),
          gesturesType: GesturesType.touch,
          isActive: false,
        ),
        deviceOrientation: DeviceOrientation.portraitUp,
      );

      /// Attempt to use sensors immediately after touch leave, should be blocked
      final blocked = resolver.resolve(
        const TiltStreamModel(
          position: Offset(5, 6),
          gesturesType: GesturesType.sensors,
        ),
        deviceOrientation: DeviceOrientation.portraitUp,
      );

      expect(blocked.gesturesType, GesturesType.touch);
      expect(blocked.isActive, isFalse);

      /// Wait for the leave duration to pass before trying again
      await Future<void>.delayed(const Duration(milliseconds: 20));

      /// Now sensors should be accepted again
      final accepted = resolver.resolve(
        const TiltStreamModel(
          position: Offset(5, 6),
          gesturesType: GesturesType.sensors,
        ),
        deviceOrientation: DeviceOrientation.portraitUp,
      );

      expect(accepted.gesturesType, GesturesType.sensors);
      expect(accepted.position, const Offset(5, 6));
    });

    test('maps sensor positions by device orientation (all directions)', () {
      const input = Offset(4, 7);
      final cases = <DeviceOrientation, Offset>{
        DeviceOrientation.portraitUp: input,
        DeviceOrientation.portraitDown: const Offset(-4, -7),
        DeviceOrientation.landscapeLeft: const Offset(7, -4),
        DeviceOrientation.landscapeRight: const Offset(-7, 4),
      };
      for (final entry in cases.entries) {
        final result = resolver.resolve(
          const TiltStreamModel(
            position: input,
            gesturesType: GesturesType.sensors,
          ),
          deviceOrientation: entry.key,
        );
        expect(
          result.position,
          entry.value,
          reason: 'orientation: ${entry.key}',
        );
        expect(result.gesturesType, GesturesType.sensors);
        expect(result.isActive, isTrue);
      }
    });
  });
}
