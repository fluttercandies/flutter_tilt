import 'dart:async';

import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_config.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/internal/controllers/tilt_gestures_controller.dart';
import 'package:flutter_tilt/src/models/tilt_stream_model.dart';
import 'package:sensors_plus/sensors_plus.dart' show AccelerometerEvent;

void main() {
  group('TiltGesturesController ::', () {
    late StreamController<TiltStreamModel> tiltStreamController;
    late TiltGesturesController controller;
    late TiltConfig tiltConfig;
    late Offset initialPosition;

    setUp(() {
      tiltStreamController = StreamController<TiltStreamModel>.broadcast();
      tiltConfig = const TiltConfig(
        enableGestureSensors: true,
        leaveDuration: Duration(milliseconds: 300),
        controllerLeaveDuration: Duration(milliseconds: 500),
      );
      initialPosition = const Offset(10, 10);
      controller = TiltGesturesController(
        tiltStreamController: tiltStreamController,
        disable: false,
        fps: 60,
        tiltConfig: tiltConfig,
        position: initialPosition,
      );
    });

    tearDown(() {
      controller.dispose();
      tiltStreamController.close();
    });

    test('Initial position', () {
      expect(controller.enableTiltStream, isTrue);
      expect(
        controller.latestTiltStreamModel.position,
        equals(initialPosition),
      );
    });

    test('Tilt stream updates (sensors)', () async {
      final deviceOrientationList = DeviceOrientation.values;
      final testModel = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.sensors,
      );
      final testSensorsX = testModel.position.dx;
      final testSensorsY = testModel.position.dy;

      controller.tiltStream?.listen((_) => {});
      for (final deviceOrientation in deviceOrientationList) {
        controller.deviceOrientation = deviceOrientation;
        controller.tiltStreamController.sink.add(testModel);
        await Future.delayed(Duration.zero);

        final testPosition = switch (deviceOrientation) {
          DeviceOrientation.portraitUp => Offset(testSensorsX, testSensorsY),
          DeviceOrientation.portraitDown => -Offset(testSensorsX, testSensorsY),
          DeviceOrientation.landscapeLeft =>
            Offset(testSensorsY, -testSensorsX),
          DeviceOrientation.landscapeRight =>
            Offset(-testSensorsY, testSensorsX),
        };

        expect(controller.latestTiltStreamModel.position, testPosition);
      }

      controller.tiltStreamController.sink.add(
        const TiltStreamModel(
          position: Offset(10, 10),
          gesturesType: GesturesType.controller,
        ),
      );
      await Future.delayed(Duration.zero);
      expect(
        controller.latestTiltStreamModel.gesturesType ==
            GesturesType.controller,
        isTrue,
      );

      controller.tiltStreamController.sink.add(testModel);
      await Future.delayed(Duration.zero);
      expect(
        controller.latestTiltStreamModel.gesturesType == GesturesType.sensors,
        isFalse,
      );
    });

    testWidgets('Accelerometer updates device orientation',
        (WidgetTester tester) async {
      const landscapeMediaQueryData = MediaQueryData(size: Size(800.0, 600.0));
      const portraitMediaQueryData = MediaQueryData(size: Size(600.0, 800.0));

      /// landscapeLeft
      final landscapeLeftEvent =
          AccelerometerEvent(1.0, 0.0, 0.0, DateTime.now());
      await tester.pumpWidget(
        MediaQuery(
          data: landscapeMediaQueryData,
          child: Builder(
            builder: (BuildContext context) {
              controller.handleAccelerometerEvents(context, landscapeLeftEvent);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        controller.deviceOrientation,
        equals(DeviceOrientation.landscapeLeft),
      );

      /// landscapeRight
      final landscapeLRightEvent =
          AccelerometerEvent(-1.0, 0.0, 0.0, DateTime.now());
      await tester.pumpWidget(
        MediaQuery(
          data: landscapeMediaQueryData,
          child: Builder(
            builder: (BuildContext context) {
              controller.handleAccelerometerEvents(
                context,
                landscapeLRightEvent,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        controller.deviceOrientation,
        equals(DeviceOrientation.landscapeRight),
      );

      /// portraitUp
      final portraitUpEvent = AccelerometerEvent(0.0, 1.0, 0.0, DateTime.now());
      await tester.pumpWidget(
        MediaQuery(
          data: portraitMediaQueryData,
          child: Builder(
            builder: (BuildContext context) {
              controller.handleAccelerometerEvents(context, portraitUpEvent);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        controller.deviceOrientation,
        equals(DeviceOrientation.portraitUp),
      );

      /// portraitDown
      final portraitDownEvent =
          AccelerometerEvent(0.0, -1.0, 0.0, DateTime.now());
      await tester.pumpWidget(
        MediaQuery(
          data: portraitMediaQueryData,
          child: Builder(
            builder: (BuildContext context) {
              controller.handleAccelerometerEvents(context, portraitDownEvent);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        controller.deviceOrientation,
        equals(DeviceOrientation.portraitDown),
      );
    });
  });
}
