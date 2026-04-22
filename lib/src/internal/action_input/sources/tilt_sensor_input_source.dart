import 'dart:async' as async show StreamSubscription, Timer;

import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:flutter/widgets.dart';

import 'package:sensors_plus/sensors_plus.dart';

import '../../../config/tilt_config.dart';
import '../../../controllers/tilt_controller.dart';
import '../../../enums.dart';
import '../../../utils/utils.dart';
import 'tilt_action_input_source.dart';

/// 处理传感器的原始输入，订阅、补帧与设备方向识别
class TiltSensorInputSource implements TiltActionInputSource {
  TiltSensorInputSource({
    required this.tiltController,
    required this.disable,
    required this.fps,
    required this.tiltConfig,
  });

  final TiltController tiltController;

  /// 是否禁用输入流
  final bool disable;

  /// 传感器采样帧率
  final int fps;

  final TiltConfig tiltConfig;

  /// 当前平台是否支持传感器
  bool _canSensorsPlatformSupport = Utils.sensorsPlatformSupport();

  /// Gyroscope 订阅
  async.StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  async.StreamSubscription<GyroscopeEvent>? get gyroscopeSubscription =>
      _gyroscopeSubscription;

  /// Accelerometer 订阅
  async.StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  async.StreamSubscription<AccelerometerEvent>? get accelerometerSubscription =>
      _accelerometerSubscription;

  /// 当前设备方向
  DeviceOrientation deviceOrientation = DeviceOrientation.portraitUp;

  /// Gyroscope 采样定时器（用于补帧或限制帧率）
  async.Timer? _gyroscopeSamplingTimer;

  /// 传感器是否已初始化
  bool sensorsInitialized = false;

  /// 待分发的最新 Gyroscope 输入位置
  Offset? _pendingGyroscopeTiltPosition;

  @override
  void init(BuildContext context) {
    _initSensors(context, enableTiltStream: !disable);
  }

  @override
  void dispose() {
    cancelAccelerometerSubscription();
    cancelGyroscopeSubscription();
    cancelGyroscopeSamplingTimer();
    sensorsInitialized = false;
  }

  /// 初始化传感器
  void _initSensors(
    BuildContext context, {
    required bool enableTiltStream,
  }) {
    if (!_canSensorsPlatformSupport ||
        sensorsInitialized ||
        !enableTiltStream ||
        !tiltConfig.enableGestureSensors) {
      return;
    }

    sensorsInitialized = true;
    subscribeToDeviceOrientation(context);
    subscribeToGyroscopeTilt();
  }

  /// 取消 Gyroscope 订阅
  void cancelGyroscopeSubscription() {
    _gyroscopeSubscription?.cancel();
    _gyroscopeSubscription = null;
  }

  /// 取消 Accelerometer 订阅
  void cancelAccelerometerSubscription() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  /// 取消 Gyroscope 采样定时器
  void cancelGyroscopeSamplingTimer() {
    _gyroscopeSamplingTimer?.cancel();
    _gyroscopeSamplingTimer = null;
    _pendingGyroscopeTiltPosition = null;
  }

  /// 订阅 Gyroscope 输入，并按帧率补帧
  void subscribeToGyroscopeTilt() {
    final frameDuration = Duration(milliseconds: (1000 / fps) ~/ 1);

    _gyroscopeSubscription = gyroscopeEventStream().listen(
      (GyroscopeEvent gyroscopeEvent) {
        if (_gyroscopeSubscription == null) return;

        _pendingGyroscopeTiltPosition = Offset(
          gyroscopeEvent.y,
          gyroscopeEvent.x,
        );

        _gyroscopeSamplingTimer ??= async.Timer.periodic(
          frameDuration,
          (_) => _pushLatestGyroscopeTiltPosition(),
        );
      },
      onError: (_) {
        _canSensorsPlatformSupport = false;
        dispose();
      },
      cancelOnError: true,
    );
  }

  /// 订阅 Accelerometer 输入，用于识别设备方向
  void subscribeToDeviceOrientation(BuildContext context) {
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        if (!context.mounted) return;
        if (_accelerometerSubscription == null) return;

        handleDeviceOrientationEvent(context, event);
      },
      onError: (_) {
        _canSensorsPlatformSupport = false;
        dispose();
      },
      cancelOnError: true,
    );
  }

  /// 处理 Accelerometer 事件，识别并更新设备方向
  void handleDeviceOrientationEvent(
    BuildContext context,
    AccelerometerEvent event,
  ) {
    if (!context.mounted) return;

    final x = event.x, y = event.y, z = event.z;
    final mediaOrientation = MediaQuery.of(context).orientation;

    switch (mediaOrientation) {
      case Orientation.landscape:
        if (x.abs() > y.abs() && x.abs() > z.abs()) {
          if (x > 0) {
            deviceOrientation = DeviceOrientation.landscapeLeft;
          } else {
            deviceOrientation = DeviceOrientation.landscapeRight;
          }
        }
      case Orientation.portrait:
        if (y.abs() > x.abs() && y.abs() > z.abs()) {
          if (y > 0) {
            deviceOrientation = DeviceOrientation.portraitUp;
          } else {
            deviceOrientation = DeviceOrientation.portraitDown;
          }
        }
    }
  }

  /// 推送最新 Gyroscope 输入到 TiltController
  void _pushLatestGyroscopeTiltPosition() {
    if (_pendingGyroscopeTiltPosition != null) {
      tiltController.move(
        position: _pendingGyroscopeTiltPosition!,
        gesturesType: GesturesType.sensors,
      );
    }
  }
}
