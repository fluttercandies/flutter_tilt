import 'dart:async' as async;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:stream_transform/stream_transform.dart';

import '../utils.dart';
import '../enums.dart';
import '../data/tilt_data.dart';
import '../config/tilt_config.dart';

/// Tilt StreamBuilder
class TiltStreamBuilder extends StatefulWidget {
  /// Tilt StreamBuilder
  ///
  /// 手势相关输入操作
  const TiltStreamBuilder({
    super.key,
    required this.tiltStreamController,
    required this.disable,
    required this.fps,
    required this.tiltConfig,
    required this.position,
    required this.builder,
  });

  /// Touch 和 Hover 的 TiltStreamController
  final async.StreamController<TiltStream> tiltStreamController;

  /// 是否禁用
  final bool disable;

  final int fps;

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
  bool get _disable => widget.disable;
  int get _fps => widget.fps;
  TiltConfig get _tiltConfig => widget.tiltConfig;
  Offset get _position => widget.position;
  async.StreamController<TiltStream> get _tiltStreamController =>
      widget.tiltStreamController;
  Widget Function(BuildContext, AsyncSnapshot<TiltStream>) get _builder =>
      widget.builder;

  /// 是否开启 Stream
  bool get enableStream => !_disable;

  /// 传感器平台支持
  bool canSensorsPlatformSupport = Utils.sensorsPlatformSupport();

  /// 初始 TiltStream
  late TiltStream initialTiltStream = TiltStream(
    position: _position,
    gesturesType: GesturesType.none,
  );

  /// Tilt Stream
  late Stream<TiltStream> currentTiltStream;

  /// 是否开启传感器
  bool enableSensors = true;

  /// 最新 TiltStream（缓存）
  late TiltStream latestTiltStream = initialTiltStream;

  /// 设备方向
  DeviceOrientation deviceOrientation = DeviceOrientation.portraitUp;

  /// 手势协调器
  async.Timer? _gesturesHarmonizerTimer;

  @override
  void initState() {
    super.initState();
    currentTiltStream = _tiltStreamController.stream;

    /// 传感器处理
    if (canSensorsPlatformSupport &&
        enableStream &&
        _tiltConfig.enableGestureSensors) {
      /// 避免无主要传感器的设备使用
      gyroscopeEventStream()
          .listen(
            null,
            onError: (_) => canSensorsPlatformSupport = false,
            cancelOnError: true,
          )
          .cancel();

      if (canSensorsPlatformSupport) {
        /// 加速度计事件处理（如：设备方向）
        accelerometerEventStream().listen(handleAccelerometerEvents);

        /// 陀螺仪处理
        gyroscopeEventStream()
            .map<TiltStream>(
              (gyroscopeEvent) => TiltStream(
                position: Offset(gyroscopeEvent.y, gyroscopeEvent.x),
                gesturesType: GesturesType.sensors,
              ),
            )
            .combineLatest(
              Stream<void>.periodic(Duration(milliseconds: (1000 / _fps) ~/ 1)),
              (p0, _) => p0,
            )
            .throttle(
              Duration(milliseconds: (1000 / _fps) ~/ 1),
              trailing: true,
            )
            .listen(
          (TiltStream tiltStream) {
            _tiltStreamController.sink.add(tiltStream);
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _gesturesHarmonizerTimer?.cancel();
    _tiltStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TiltStream>(
      stream: enableStream ? currentTiltStream.map(filterTiltStream) : null,
      initialData: initialTiltStream,
      builder: _builder,
    );
  }

  /// 过滤 TiltStream
  TiltStream filterTiltStream(TiltStream tiltStream) {
    /// 当前手势是否最高优先级
    final bool isHighPriority = gesturesTypePriority(
            tiltStream.gesturesType, latestTiltStream.gesturesType) ==
        tiltStream.gesturesType;

    switch (tiltStream.gesturesType) {
      case GesturesType.none:
        break;
      case GesturesType.touch || GesturesType.hover || GesturesType.controller:
        if (isHighPriority) {
          latestTiltStream = tiltStream;
        } else {
          if (!latestTiltStream.gestureUse) latestTiltStream = tiltStream;
        }

        /// 避免 sensors 与其他手势触发冲突
        if (!tiltStream.gestureUse) {
          gesturesHarmonizerTimer();
          enableSensors = true;
        } else {
          enableSensors = false;
        }
        break;
      case GesturesType.sensors:
        // 避免 sensors 与其他手势触发冲突
        if (enableSensors && _gesturesHarmonizerTimer == null) {
          final sensorsX = tiltStream.position.dx;
          final sensorsY = tiltStream.position.dy;
          final Offset tiltPosition = switch (deviceOrientation) {
            DeviceOrientation.portraitUp => Offset(sensorsX, sensorsY),
            DeviceOrientation.portraitDown => -Offset(sensorsX, sensorsY),
            DeviceOrientation.landscapeLeft => Offset(sensorsY, -sensorsX),
            DeviceOrientation.landscapeRight => Offset(-sensorsY, sensorsX),
          };
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
  /// 开启避免 sensors 与其他手势冲突的计时器
  ///
  /// 避免其他手势离开后的动画与 sensors 冲突（出现闪现）
  void gesturesHarmonizerTimer() {
    _gesturesHarmonizerTimer?.cancel();
    _gesturesHarmonizerTimer = async.Timer(
      _tiltConfig.leaveDuration,
      () => _gesturesHarmonizerTimer = null,
    );
  }

  /// 手势优先级比较
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
}
