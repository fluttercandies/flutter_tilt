import 'dart:async' as async;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:stream_transform/stream_transform.dart';

import 'utils.dart';
import 'enums.dart';
import 'data/tilt_data.dart';
import 'config/tilt_config.dart';

/// Tilt StreamBuilder
class TiltStreamBuilder extends StatefulWidget {
  /// Tilt StreamBuilder
  ///
  /// 手势相关输入操作
  const TiltStreamBuilder({
    super.key,
    required this.tiltStreamController,
    required this.disable,
    required this.tiltConfig,
    required this.position,
    required this.builder,
  });

  /// Touch 和 Hover 的 TiltStreamController
  final async.StreamController<TiltStream> tiltStreamController;

  /// 是否禁用
  final bool disable;

  /// TiltConfig
  final TiltConfig tiltConfig;

  /// 当前坐标
  final Offset position;

  /// 传感器 builder
  final Widget Function(BuildContext, AsyncSnapshot<TiltStream>) builder;

  @override
  State<TiltStreamBuilder> createState() => _TiltStreamBuilderState();
}

class _TiltStreamBuilderState extends State<TiltStreamBuilder> {
  bool get disable => widget.disable;
  TiltConfig get tiltConfig => widget.tiltConfig;
  Offset get position => widget.position;
  async.StreamController<TiltStream> get tiltStreamController =>
      widget.tiltStreamController;
  Widget Function(BuildContext, AsyncSnapshot<TiltStream>) get builder =>
      widget.builder;

  /// 是否开启 Stream
  bool get enableStream => !disable;

  /// 传感器平台支持
  bool canSensorsPlatformSupport = sensorsPlatformSupport();

  /// Touch, Hover 的 Stream
  late Stream<TiltStream> currentTiltStream;

  /// 陀螺仪 Stream
  late Stream<TiltStream> currentGyroscopeStream;

  /// 是否开启传感器
  late bool enableSensors = tiltConfig.enableGestureSensors;

  /// 最新 TiltStream（缓存）
  late TiltStream latestTiltStream =
      TiltStream(position: position, gesturesType: GesturesType.none);

  /// 设备方向
  DeviceOrientation deviceOrientation = DeviceOrientation.portraitUp;

  /// 手势协调器
  async.Timer? _gesturesHarmonizerTimer;

  @override
  void initState() {
    super.initState();

    /// 避免无主要传感器的设备使用
    if (canSensorsPlatformSupport && enableStream && enableSensors) {
      gyroscopeEvents
          .listen(
            null,
            onError: (_) => canSensorsPlatformSupport = false,
            cancelOnError: true,
          )
          .cancel();

      /// 加速度计事件处理（如：设备方向）
      accelerometerEvents.listen(handleAccelerometerEvents);
    }

    currentTiltStream = tiltStreamController.stream;
    currentGyroscopeStream = gyroscopeEvents
        .map<TiltStream>(
          (gyroscopeEvent) => TiltStream(
            position: Offset(gyroscopeEvent.y, gyroscopeEvent.x),
            gesturesType: GesturesType.sensors,
          ),
        )
        .combineLatest(
          Stream<void>.periodic(Duration.zero),
          (p0, _) => p0,
        );
  }

  @override
  void dispose() {
    _gesturesHarmonizerTimer?.cancel();
    tiltStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TiltStream>(
      stream: enableStream
          ? currentTiltStream.mergeAll([
              if (canSensorsPlatformSupport && tiltConfig.enableGestureSensors)
                currentGyroscopeStream,
            ]).map(filterTiltStream)
          : null,
      initialData: TiltStream(
        position: position,
        gesturesType: GesturesType.none,
      ),
      builder: builder,
    );
  }

  /// 过滤 TiltStream
  TiltStream filterTiltStream(TiltStream tiltStream) {
    switch (tiltStream.gesturesType) {
      case GesturesType.none:
        latestTiltStream = tiltStream;
        break;
      case GesturesType.touch:
        // 避免 touch 与 sensors 冲突
        if (canSensorsPlatformSupport &&
            tiltConfig.enableGestureSensors &&
            (tiltStream.enableRevert ?? enableSensors)) {
          gesturesHarmonizerTimer();
          enableSensors = true;
        } else {
          enableSensors = false;
        }
        latestTiltStream = tiltStream;
        break;
      case GesturesType.hover:
        latestTiltStream = tiltStream;
        break;
      case GesturesType.sensors:
        if (canSensorsPlatformSupport &&
            enableSensors &&
            _gesturesHarmonizerTimer == null) {
          final sensorsX = tiltStream.position.dx;
          final sensorsY = tiltStream.position.dy;
          late Offset tiltPosition;
          switch (deviceOrientation) {
            case DeviceOrientation.portraitUp:
              tiltPosition = Offset(sensorsX, sensorsY);
              break;
            case DeviceOrientation.portraitDown:
              tiltPosition = -Offset(sensorsX, sensorsY);
              break;
            case DeviceOrientation.landscapeLeft:
              tiltPosition = Offset(sensorsY, -sensorsX);
              break;
            case DeviceOrientation.landscapeRight:
              tiltPosition = Offset(-sensorsY, sensorsX);
              break;
          }
          latestTiltStream = TiltStream(
            position: tiltPosition,
            gesturesType: tiltStream.gesturesType,
          );
        }
        break;
    }
    return latestTiltStream;
  }

  /// 加速度计事件处理（如：设备方向）
  void handleAccelerometerEvents(AccelerometerEvent event) {
    final x = event.x, y = event.y, z = event.z;
    if (!mounted) return;
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
        break;
      case Orientation.portrait:
        if (y.abs() > x.abs() && y.abs() > z.abs()) {
          if (y > 0) {
            deviceOrientation = DeviceOrientation.portraitUp;
          } else {
            deviceOrientation = DeviceOrientation.portraitDown;
          }
        }
        break;
    }
  }

  /// 手势协调器
  ///
  /// 开启避免 touch、hover 与 sensors 冲突的计时器
  ///
  /// 避免 touch、hover 离开后的动画与 sensors 冲突（出现闪现）
  void gesturesHarmonizerTimer() {
    _gesturesHarmonizerTimer?.cancel();
    _gesturesHarmonizerTimer = async.Timer(
      tiltConfig.leaveDuration,
      () => _gesturesHarmonizerTimer = null,
    );
  }
}
