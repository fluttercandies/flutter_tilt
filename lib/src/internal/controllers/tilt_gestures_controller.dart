import 'dart:async' as async show StreamController, StreamSubscription, Timer;
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:flutter/widgets.dart';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:stream_transform/stream_transform.dart';

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
    required this.position,
  });

  /// TiltStreamController
  final async.StreamController<TiltStreamModel> tiltStreamController;

  /// 是否禁用所有效果
  final bool disable;

  final int fps;

  final TiltConfig tiltConfig;

  /// 当前坐标
  final Offset position;

  /// 传感器平台支持
  bool _canSensorsPlatformSupport = Utils.sensorsPlatformSupport();

  final List<async.StreamSubscription> streamSubscriptions = [];

  /// 设备方向
  DeviceOrientation deviceOrientation = DeviceOrientation.portraitUp;

  /// 是否开启传感器
  bool _enableSensors = true;

  /// 初始 TiltStreamModel
  late TiltStreamModel initialTiltStreamModel = TiltStreamModel(
    position: position,
    gesturesType: GesturesType.none,
  );

  /// 最新 TiltStreamModel（缓存）
  late TiltStreamModel latestTiltStreamModel = initialTiltStreamModel;

  /// 手势协调器
  async.Timer? _gesturesHarmonizerTimer;

  /// 是否开启 TiltStream
  bool get enableTiltStream => !disable;

  Stream<TiltStreamModel>? get tiltStream => enableTiltStream
      ? tiltStreamController.stream.map(filterTiltStream)
      : null;

  void dispose() {
    _gesturesHarmonizerTimer?.cancel();
    for (final sub in streamSubscriptions) {
      sub.cancel();
    }
  }

  /// 过滤 TiltStream
  TiltStreamModel filterTiltStream(TiltStreamModel tiltStreamModel) {
    /// 当前手势是否最高优先级
    final bool isHighPriority = gesturesTypePriority(
          tiltStreamModel.gesturesType,
          latestTiltStreamModel.gesturesType,
        ) ==
        tiltStreamModel.gesturesType;

    switch (tiltStreamModel.gesturesType) {
      case GesturesType.none:
        break;
      case GesturesType.touch || GesturesType.hover || GesturesType.controller:
        if (isHighPriority) {
          latestTiltStreamModel = tiltStreamModel;
        } else {
          if (!latestTiltStreamModel.gestureUse) {
            latestTiltStreamModel = tiltStreamModel;
          }
        }

        /// 避免 sensors 与其他手势触发冲突
        if (!tiltStreamModel.gestureUse) {
          switch (tiltStreamModel.gesturesType) {
            case GesturesType.touch || GesturesType.hover:
              _gesturesHarmonizer(tiltConfig.leaveDuration);
            case GesturesType.controller:
              _gesturesHarmonizer(tiltConfig.controllerLeaveDuration);
            default:
              break;
          }
          _enableSensors = true;
        } else {
          _enableSensors = false;
        }
      case GesturesType.sensors:
        // 避免 sensors 与其他手势触发冲突
        if (_enableSensors && _gesturesHarmonizerTimer == null) {
          final sensorsX = tiltStreamModel.position.dx;
          final sensorsY = tiltStreamModel.position.dy;
          final Offset tiltPosition = switch (deviceOrientation) {
            DeviceOrientation.portraitUp => Offset(sensorsX, sensorsY),
            DeviceOrientation.portraitDown => -Offset(sensorsX, sensorsY),
            DeviceOrientation.landscapeLeft => Offset(sensorsY, -sensorsX),
            DeviceOrientation.landscapeRight => Offset(-sensorsY, sensorsX),
          };
          latestTiltStreamModel = TiltStreamModel(
            position: tiltPosition,
            gesturesType: tiltStreamModel.gesturesType,
          );
        }
    }
    return latestTiltStreamModel;
  }

  /// 手势协调器
  ///
  /// 开启避免 sensors 与其他手势冲突的计时器
  ///
  /// 避免其他手势离开后的动画与 sensors 冲突（出现闪现）
  void _gesturesHarmonizer(Duration duration) {
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
  /// @return [GesturesType] 优先级最高的类型
  GesturesType gesturesTypePriority(
    GesturesType gesturesType1,
    GesturesType gesturesType2,
  ) {
    if (gesturesType1 == gesturesType2) return gesturesType1;

    /// 手势优先级（下标越小，优先级越高）
    final List<GesturesType> gesturePriority = [
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
        !enableTiltStream ||
        !tiltConfig.enableGestureSensors) {
      return;
    }

    /// 加速度计事件处理（如：设备方向）
    streamSubscriptions.add(
      accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          if (!context.mounted) return;
          handleAccelerometerEvents(context, event);
        },
        onError: (_) => _canSensorsPlatformSupport = false,
        cancelOnError: true,
      ),
    );

    /// 陀螺仪处理
    streamSubscriptions.add(
      gyroscopeEventStream()
          .map<TiltStreamModel>(
            (gyroscopeEvent) => TiltStreamModel(
              position: Offset(gyroscopeEvent.y, gyroscopeEvent.x),
              gesturesType: GesturesType.sensors,
            ),
          )
          .combineLatest(
            Stream<void>.periodic(Duration(milliseconds: (1000 / fps) ~/ 1)),
            (p0, _) => p0,
          )
          .throttle(
            Duration(milliseconds: (1000 / fps) ~/ 1),
            trailing: true,
          )
          .listen(
        (TiltStreamModel tiltStreamModel) {
          if (tiltStreamController.hasListener) {
            tiltStreamController.sink.add(tiltStreamModel);
          }
        },
        onError: (_) => _canSensorsPlatformSupport = false,
        cancelOnError: true,
      ),
    );
  }

  /// 加速度计事件处理（如：设备方向）
  void handleAccelerometerEvents(
    BuildContext context,
    AccelerometerEvent event,
  ) {
    final x = event.x, y = event.y, z = event.z;
    if (!context.mounted) return;
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
