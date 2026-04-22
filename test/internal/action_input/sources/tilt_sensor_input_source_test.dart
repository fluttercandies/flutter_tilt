import 'dart:async';

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:flutter_tilt/src/internal/action_input/sources/tilt_sensor_input_source.dart';
import 'package:sensors_plus/sensors_plus.dart' show AccelerometerEvent;

import '../../../sensors_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TiltSensorInputSource ::', () {
    const fps = 60;
    late TiltController tiltController;
    late TiltSensorInputSource inputSource;
    late int frameDurationMs;

    setUp(() {
      tiltController = TiltController();
      inputSource = TiltSensorInputSource(
        tiltController: tiltController,
        disable: false,
        fps: fps,
        tiltConfig: const TiltConfig(enableGestureSensors: true),
      );
      frameDurationMs = (1000 / fps) ~/ 1;
    });

    tearDown(() {
      inputSource.dispose();
      tiltController.dispose();
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('Sensors stream subscriptions', (WidgetTester tester) async {
      var currentGesturesType = GesturesType.none;
      var currentPosition = Offset.zero;
      var sensorFrameCount = 0;
      var replayedFrameCount = 0;
      late StreamSubscription<TiltStreamModel> firstSubscription;

      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      /// 模拟传感器
      SensorsMock.initMockSensorsMethodChannel([
        SensorsMock.accelerometerMethodName,
        SensorsMock.gyroscopeMethodName,
      ]);
      final date = DateTime.now();
      final accelerometerSensorData = <List<double>>[
        [1.0, 2.0, 3.0, date.microsecondsSinceEpoch.toDouble()],
      ];
      final gyroscopeSensorData = <List<double>>[
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
                /// 初始化传感器
                inputSource.init(context);
                return const SizedBox();
              },
            ),
          );

          firstSubscription = tiltController.stream.listen(
            (TiltStreamModel tiltStreamModel) {
              currentPosition = tiltStreamModel.position;
              currentGesturesType = tiltStreamModel.gesturesType;
              if (tiltStreamModel.gesturesType == GesturesType.sensors) {
                sensorFrameCount++;
              }
            },
          );

          /// 延迟 3 帧，等待数据 sensorFrameCount 累加到 3
          await Future.delayed(
            Duration(milliseconds: frameDurationMs * 3),
          );

          /// 取消订阅后，等待 2 帧
          await firstSubscription.cancel();
          await Future.delayed(
            Duration(milliseconds: frameDurationMs * 2),
          );

          final replaySubscription = tiltController.stream.listen(
            (TiltStreamModel tiltStreamModel) {
              if (tiltStreamModel.gesturesType == GesturesType.sensors) {
                replayedFrameCount++;
              }
            },
          );

          /// 延迟 3 帧，等待数据 replayedFrameCount 累加到 3
          await Future.delayed(
            Duration(milliseconds: frameDurationMs * 3),
          );
          await replaySubscription.cancel();
        },
      );

      expect(currentGesturesType, GesturesType.sensors);
      expect(
        currentPosition,
        Offset(gyroscopeSensorData.last[1], gyroscopeSensorData.last[0]),
      );
      expect(sensorFrameCount, 3);
      expect(replayedFrameCount, 3);

      expect(inputSource.gyroscopeSubscription, isNotNull);
      expect(inputSource.accelerometerSubscription, isNotNull);

      await tester.runAsync(() async {
        /// 取消传感器订阅
        inputSource.dispose();
      });
      expect(inputSource.gyroscopeSubscription, isNull);
      expect(inputSource.accelerometerSubscription, isNull);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('initSensors only subscribes once', (
      WidgetTester tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.runAsync(() async {
        await tester.pumpWidget(
          Builder(
            builder: (BuildContext context) {
              expect(inputSource.sensorsInitialized, isFalse);

              inputSource.init(context);
              expect(inputSource.sensorsInitialized, isTrue);
              expect(inputSource.gyroscopeSubscription, isNotNull);
              expect(inputSource.accelerometerSubscription, isNotNull);

              inputSource.init(context);
              inputSource.dispose();
              expect(inputSource.sensorsInitialized, isFalse);
              return const SizedBox();
            },
          ),
        );
      });

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('updates device orientation', (WidgetTester tester) async {
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
              inputSource.handleDeviceOrientationEvent(
                context,
                landscapeLeftEvent,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        inputSource.deviceOrientation,
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
              inputSource.handleDeviceOrientationEvent(
                context,
                landscapeLRightEvent,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        inputSource.deviceOrientation,
        equals(DeviceOrientation.landscapeRight),
      );

      /// portraitUp
      final portraitUpEvent = AccelerometerEvent(0.0, 1.0, 0.0, DateTime.now());
      await tester.pumpWidget(
        MediaQuery(
          data: portraitMediaQueryData,
          child: Builder(
            builder: (BuildContext context) {
              inputSource.handleDeviceOrientationEvent(
                context,
                portraitUpEvent,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        inputSource.deviceOrientation,
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
              inputSource.handleDeviceOrientationEvent(
                context,
                portraitDownEvent,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        inputSource.deviceOrientation,
        equals(DeviceOrientation.portraitDown),
      );
    });
  });
}
