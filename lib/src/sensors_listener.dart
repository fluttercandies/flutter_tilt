import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:flutter_tilt/src/type/tilt_type.dart';

/// 传感器监听
class SensorsListener extends StatefulWidget {
  /// 传感器监听
  const SensorsListener({
    super.key,
    required this.isSensorsListener,
    required this.position,
    required this.tiltConfig,
    required this.builder,
  });

  /// 是否传感器监听
  final bool isSensorsListener;

  /// 当前坐标（与手势一致）
  final Offset position;

  /// TiltConfig
  final TiltConfig tiltConfig;

  /// 传感器 builder
  final Widget Function(BuildContext, AsyncSnapshot<GyroscopeEvent>) builder;

  @override
  State<SensorsListener> createState() => _SensorsListenerState();
}

class _SensorsListenerState extends State<SensorsListener> {
  bool get isSensorsListener => widget.isSensorsListener;
  Offset get position => widget.position;
  TiltConfig get tiltConfig => widget.tiltConfig;
  Widget Function(BuildContext, AsyncSnapshot<GyroscopeEvent>) get builder =>
      widget.builder;

  /// 是否监听
  late bool isListener = isSensorsListener;

  @override
  void initState() {
    super.initState();

    /// 避免没有陀螺仪的设备使用
    if (isListener) {
      gyroscopeEvents
          .listen(
            null,
            onError: (error) => isListener = false,
            cancelOnError: true,
          )
          .cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GyroscopeEvent>(
      stream: isListener
          ? gyroscopeEvents.combineLatest<void, GyroscopeEvent>(
              /// 发送数据流的周期，
              /// 为了提高 GyroscopeEvent 在视图的发送频率，
              /// 但不代表 GyroscopeEvent 实际的发送频率
              Stream.periodic(Duration(milliseconds: 0)),
              (gyroscopeEvent, _) => gyroscopeEvent,
            )
          : null,
      initialData: GyroscopeEvent(position.dx, position.dy, 0),
      builder: builder,
    );
  }
}
