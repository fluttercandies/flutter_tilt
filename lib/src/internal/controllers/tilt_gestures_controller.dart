import 'dart:async' as async show StreamController, StreamSubscription, Timer;
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:flutter/widgets.dart';

import 'package:sensors_plus/sensors_plus.dart';

import '../../config/tilt_config.dart';
import '../../enums.dart';
import '../../models/tilt_stream_model.dart';
import '../../utils.dart';

/// 倾斜手势控制器
class TiltGesturesController {
  TiltGesturesController({
    required this.tiltStreamController,
    required this.disable,
    required this.fps,
    required this.tiltConfig,
    required this.initialPosition,
  });

  /// TiltStreamController
  final async.StreamController<TiltStreamModel> tiltStreamController;

  /// 是否禁用所有效果
  final bool disable;

  final int fps;

  final TiltConfig tiltConfig;

  /// 初始坐标
  final Offset initialPosition;

  /// 传感器平台支持
  bool _canSensorsPlatformSupport = Utils.sensorsPlatformSupport();

  async.StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  async.StreamSubscription<GyroscopeEvent>? get gyroscopeSubscription =>
      _gyroscopeSubscription;

  async.StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  async.StreamSubscription<AccelerometerEvent>? get accelerometerSubscription =>
      _accelerometerSubscription;

  /// 设备方向
  DeviceOrientation deviceOrientation = DeviceOrientation.portraitUp;

  /// 是否开启传感器
  bool _enableSensors = true;

  /// 初始 TiltStreamModel
  late TiltStreamModel initialTiltStreamModel = TiltStreamModel(
    position: initialPosition,
    gesturesType: GesturesType.none,
  );

  /// 最新 TiltStreamModel（缓存）
  late TiltStreamModel latestTiltStreamModel = initialTiltStreamModel;

  /// 手势协调器
  async.Timer? _gesturesHarmonizerTimer;

  /// 陀螺仪采样定时器
  async.Timer? _gyroscopeSamplingTimer;

  /// 是否已完成传感器订阅初始化
  bool _sensorsInitialized = false;

  /// 最近一帧可用于补帧/限流的陀螺仪数据
  TiltStreamModel? _pendingGyroscopeTiltStreamModel;

  /// 是否开启 TiltStream
  bool get enableTiltStream => !disable;

  Stream<TiltStreamModel>? get tiltStream => enableTiltStream
      ? tiltStreamController.stream.map(filterTiltStream)
      : null;

  void dispose() {
    disposeSensors();
    cancelGesturesHarmonizerTimer();
  }

  void disposeSensors() {
    cancelAccelerometerSubscription();
    cancelGyroscopeSubscription();
    cancelGyroscopeSamplingTimer();
    _sensorsInitialized = false;
  }

  /// 取消陀螺仪订阅
  void cancelGyroscopeSubscription() {
    _gyroscopeSubscription?.cancel();
    _gyroscopeSubscription = null;
  }

  /// 取消加速度计订阅
  void cancelAccelerometerSubscription() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  /// 取消手势协调器
  void cancelGesturesHarmonizerTimer() {
    _gesturesHarmonizerTimer?.cancel();
    _gesturesHarmonizerTimer = null;
  }

  /// 取消陀螺仪采样定时器（补帧/限流）
  void cancelGyroscopeSamplingTimer() {
    _gyroscopeSamplingTimer?.cancel();
    _gyroscopeSamplingTimer = null;
    _pendingGyroscopeTiltStreamModel = null;
  }

  /// 过滤 TiltStream
  TiltStreamModel filterTiltStream(TiltStreamModel tiltStreamModel) {
    switch (tiltStreamModel.gesturesType) {
      case GesturesType.none:
        break;
      case GesturesType.touch || GesturesType.hover || GesturesType.controller:
        {
          if (latestTiltStreamModel == tiltStreamModel) {
            return tiltStreamModel;
          }

          /// 当前手势是否高优先级
          final isHighPriority = gesturesTypePriority(
                tiltStreamModel.gesturesType,
                latestTiltStreamModel.gesturesType,
              ) ==
              tiltStreamModel.gesturesType;

          if (isHighPriority || !latestTiltStreamModel.gestureUse) {
            latestTiltStreamModel = tiltStreamModel;
          }

          /// 避免 sensors 与其他手势触发冲突
          if (!tiltStreamModel.gestureUse) {
            _handleGestureConflict(tiltStreamModel.gesturesType);
            _enableSensors = true;
          } else {
            _enableSensors = false;
          }
        }
      case GesturesType.sensors:
        {
          /// 避免 sensors 与其他手势触发冲突
          if (_enableSensors && _gesturesHarmonizerTimer == null) {
            _updateSensorTiltPosition(tiltStreamModel);
          }
        }
    }
    return latestTiltStreamModel;
  }

  /// 更新 sensors 对应的倾斜位置
  void _updateSensorTiltPosition(TiltStreamModel tiltStreamModel) {
    final sensorsX = tiltStreamModel.position.dx;
    final sensorsY = tiltStreamModel.position.dy;
    final tiltPosition = switch (deviceOrientation) {
      DeviceOrientation.portraitUp => Offset(sensorsX, sensorsY),
      DeviceOrientation.portraitDown => -Offset(sensorsX, sensorsY),
      DeviceOrientation.landscapeLeft => Offset(sensorsY, -sensorsX),
      DeviceOrientation.landscapeRight => Offset(-sensorsY, sensorsX),
    };
    latestTiltStreamModel = TiltStreamModel(
      position: tiltPosition,
      gesturesType: tiltStreamModel.gesturesType,
      gestureUse: true,
    );
  }

  /// 处理对应手势的冲突
  void _handleGestureConflict(GesturesType gesturesType) {
    final duration = switch (gesturesType) {
      GesturesType.touch || GesturesType.hover => tiltConfig.leaveDuration,
      GesturesType.controller => tiltConfig.controllerLeaveDuration,
      _ => null
    };
    if (duration != null) {
      _gesturesHarmonizer(duration);
    }
  }

  /// 手势协调器
  ///
  /// 开启避免 sensors 与其他手势冲突的计时器
  ///
  /// 避免其他手势离开后的动画与 sensors 冲突（出现闪现）
  void _gesturesHarmonizer(Duration duration) {
    if (_gesturesHarmonizerTimer != null) return;
    _gesturesHarmonizerTimer?.cancel();
    _gesturesHarmonizerTimer = async.Timer(
      duration,
      () => _gesturesHarmonizerTimer = null,
    );
  }

  /// 手势优先级比较
  ///
  /// {@macro tilt.GesturesType.gesturePriority}
  ///
  /// - [gesturesType1] 手势类型1
  /// - [gesturesType2] 手势类型2
  ///
  /// @return [GesturesType] 优先级最高的手势类型
  GesturesType gesturesTypePriority(
    GesturesType gesturesType1,
    GesturesType gesturesType2,
  ) {
    if (gesturesType1 == gesturesType2) return gesturesType1;

    /// 手势优先级（下标越小，优先级越高）
    final gesturePriority = <GesturesType>[
      GesturesType.touch,
      GesturesType.hover,
      GesturesType.controller,
      GesturesType.sensors,
      GesturesType.none,
    ];
    return gesturePriority.indexOf(gesturesType1) <
            gesturePriority.indexOf(gesturesType2)
        ? gesturesType1
        : gesturesType2;
  }

  /// 初始化传感器
  void initSensors(BuildContext context) {
    if (!_canSensorsPlatformSupport ||
        _sensorsInitialized ||
        !enableTiltStream ||
        !tiltConfig.enableGestureSensors) {
      return;
    }

    _sensorsInitialized = true;

    /// 订阅设备方向事件
    subscribeToDeviceOrientation(context);

    /// 订阅陀螺仪倾斜事件
    subscribeToGyroscopeTilt();
  }

  /// 订阅陀螺仪倾斜事件
  void subscribeToGyroscopeTilt() {
    final frameDuration = Duration(milliseconds: (1000 / fps) ~/ 1);

    _gyroscopeSubscription = gyroscopeEventStream().listen(
      (GyroscopeEvent gyroscopeEvent) {
        if (_gyroscopeSubscription == null) return;

        _pendingGyroscopeTiltStreamModel = TiltStreamModel(
          position: Offset(gyroscopeEvent.y, gyroscopeEvent.x),
          gesturesType: GesturesType.sensors,
          gestureUse: true,
        );

        /// 如果陀螺仪存在数据，则开启陀螺仪采样定时器（补帧/限流）
        _gyroscopeSamplingTimer ??= async.Timer.periodic(
          frameDuration,
          (_) => _pushLatestGyroscopeTiltStreamModel(),
        );
      },
      onError: (_) {
        _canSensorsPlatformSupport = false;
        disposeSensors();
      },
      cancelOnError: true,
    );
  }

  /// 按帧推送当前缓存的最新陀螺仪值，用于补帧和限流
  void _pushLatestGyroscopeTiltStreamModel() {
    final tiltStreamModel = _pendingGyroscopeTiltStreamModel;

    if (tiltStreamModel != null) {
      tiltStreamController.sink.add(tiltStreamModel);
    }
  }

  /// 订阅设备方向事件
  void subscribeToDeviceOrientation(BuildContext context) {
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        if (!context.mounted) return;
        if (_accelerometerSubscription == null) return;

        handleDeviceOrientationEvent(context, event);
      },
      onError: (_) {
        _canSensorsPlatformSupport = false;
        disposeSensors();
      },
      cancelOnError: true,
    );
  }

  /// 处理设备方向事件
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
}
