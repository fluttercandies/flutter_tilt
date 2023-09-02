import 'dart:async' as async;
import 'package:flutter/widgets.dart';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/utils.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';
import 'package:flutter_tilt/src/model/tilt_model.dart';

/// Tilt StreamBuilder
class TiltStreamBuilder extends StatefulWidget {
  /// Tilt StreamBuilder
  ///
  /// 手势相关输入操作
  const TiltStreamBuilder({
    super.key,
    required this.tiltStreamController,
    required this.isInit,
    required this.disable,
    required this.tiltConfig,
    required this.position,
    required this.builder,
  });

  /// Touch 和 Hover 的 TiltStreamController
  final async.StreamController<TiltStream> tiltStreamController;

  /// 是否初始化
  final bool isInit;

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
  bool get isInit => widget.isInit;
  bool get disable => widget.disable;
  TiltConfig get tiltConfig => widget.tiltConfig;
  Offset get position => widget.position;
  async.StreamController<TiltStream> get tiltStreamController =>
      widget.tiltStreamController;
  Widget Function(BuildContext, AsyncSnapshot<TiltStream>) get builder =>
      widget.builder;

  /// 是否开启 Stream
  bool get enableStream => !disable && canSensorsPlatformSupport;

  /// Touch, Hover 的 Stream
  Stream<TiltStream> get currentTiltStream => tiltStreamController.stream;

  /// 陀螺仪 Stream
  Stream<TiltStream> get currentGyroscopeStream => gyroscopeEvents
      .map<TiltStream>(
        (gyroscopeEvent) => TiltStream(
          position: Offset(gyroscopeEvent.y, gyroscopeEvent.x),
          gesturesType: GesturesType.sensors,
        ),
      )
      .combineLatest(
        Stream<void>.periodic(Duration(milliseconds: 0)),
        (p0, _) => p0,
      );

  /// 传感器平台支持
  final bool canSensorsPlatformSupport = sensorsPlatformSupport();

  /// 是否开启传感器
  late bool enableSensors = tiltConfig.enableGestureSensors;

  /// 最新 TiltStream（缓存）
  late TiltStream latestTiltStream =
      TiltStream(position: position, gesturesType: GesturesType.none);

  @override
  void initState() {
    super.initState();

    /// 避免没有陀螺仪的设备使用
    if (enableStream && enableSensors) {
      gyroscopeEvents
          .listen(
            null,
            onError: (_) => enableSensors = false,
            cancelOnError: true,
          )
          .cancel();
    }
  }

  @override
  void dispose() {
    tiltStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TiltStream>(
      stream: isInit && enableStream
          ? currentTiltStream.mergeAll([
              if (enableSensors) currentGyroscopeStream,
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
    if (tiltStream.gesturesType == GesturesType.touch ||
        tiltStream.gesturesType == GesturesType.hover) {
      /// 避免 touch、hover 与 sensors 冲突
      if (tiltStream.enableSensors ?? enableSensors) {
        enableSensors = true;
      } else {
        enableSensors = false;
      }
      latestTiltStream = tiltStream;
    }
    if (tiltStream.gesturesType == GesturesType.sensors) {
      if (enableSensors) return latestTiltStream = tiltStream;
    }
    return latestTiltStream;
  }
}
