import 'dart:async';

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/config/tilt_config.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/internal/controllers/tilt_gestures_controller.dart';
import 'package:flutter_tilt/src/models/tilt_stream_model.dart';
import 'package:sensors_plus/sensors_plus.dart' show AccelerometerEvent;

import '../../sensors_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
        initialPosition: initialPosition,
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

    testWidgets('Sensors stream subscriptions', (WidgetTester tester) async {
      GesturesType currentGesturesType = GesturesType.none;
      Offset currentPosition = Offset.zero;

      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      /// 模拟传感器
      SensorsMock.initMockSensorsMethodChannel([
        SensorsMock.accelerometerMethodName,
        SensorsMock.gyroscopeMethodName,
      ]);
      final date = DateTime.now();
      final List<List<double>> accelerometerSensorData = [
        [1.0, 2.0, 3.0, date.microsecondsSinceEpoch.toDouble()],
      ];
      final List<List<double>> gyroscopeSensorData = [
        [3.0, 4.0, 5.0, date.microsecondsSinceEpoch.toDouble()],
      ];
      SensorsMock.initMockSensorChannelData(
        SensorsMock.accelerometerChannelName,
        accelerometerSensorData,
      );
      SensorsMock.initMockSensorChannelData(
        SensorsMock.gyroscopeChannelName,
        gyroscopeSensorData,
      );

      await tester.runAsync(
        () async {
          await tester.pumpWidget(
            Builder(
              builder: (BuildContext context) {
                /// 监听数据
                tiltStreamController.stream.listen(
                  (TiltStreamModel tiltStreamModel) {
                    currentPosition = tiltStreamModel.position;
                    currentGesturesType = tiltStreamModel.gesturesType;
                  },
                );

                /// 初始化传感器
                controller.initSensors(context);
                return const SizedBox();
              },
            ),
          );

          /// 延迟 1 帧，等待数据
          await Future.delayed(
            Duration(milliseconds: (1000 / controller.fps) ~/ 1),
          );
        },
      );

      expect(currentGesturesType, GesturesType.sensors);
      expect(
        currentPosition,
        Offset(gyroscopeSensorData.last[1], gyroscopeSensorData.last[0]),
      );
      expect(controller.streamSubscriptions.length, 2);

      /// 取消订阅
      controller.dispose();
      expect(controller.streamSubscriptions.length, 0);

      debugDefaultTargetPlatformOverride = null;
    });

    test('Tilt stream updates (sensors)', () async {
      const deviceOrientationList = DeviceOrientation.values;
      const testModel = TiltStreamModel(
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

    testWidgets('Update device orientation', (WidgetTester tester) async {
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
              controller.handleDeviceOrientationEvent(
                context,
                landscapeLeftEvent,
              );
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
              controller.handleDeviceOrientationEvent(
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
              controller.handleDeviceOrientationEvent(context, portraitUpEvent);
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
              controller.handleDeviceOrientationEvent(
                context,
                portraitDownEvent,
              );
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
