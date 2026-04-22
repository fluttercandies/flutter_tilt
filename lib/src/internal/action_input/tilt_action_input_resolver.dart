import 'dart:async' as async show Timer;

import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../enums.dart';
import '../../models/tilt_stream_model.dart';

/// 统一处理 Tilt 各类输入（如手势、传感器等）的优先级和冲突
///
/// 职责：
/// - 维护当前最新的输入 [TiltStreamModel]
/// - 根据输入类型（如手势、传感器等）动态切换优先级
/// - 协调不同行为输入（如手势与传感器）之间冲突和切换时机
class TiltActionInputResolver {
  TiltActionInputResolver({
    required this.tiltConfig,
    required this.initialTiltStreamModel,
  }) : latestTiltStreamModel = initialTiltStreamModel;

  final TiltConfig tiltConfig;

  /// 初始 [TiltStreamModel]
  final TiltStreamModel initialTiltStreamModel;

  /// 当前最新的 [TiltStreamModel]
  late TiltStreamModel latestTiltStreamModel;

  /// 是否允许传感器输入生效
  bool _enableSensors = true;

  /// 手势冲突协调定时器
  async.Timer? _gesturesHarmonizerTimer;

  void dispose() {
    cancelGesturesHarmonizerTimer();
  }

  /// 取消手势冲突协调定时器
  void cancelGesturesHarmonizerTimer() {
    _gesturesHarmonizerTimer?.cancel();
    _gesturesHarmonizerTimer = null;
  }

  /// 输入流主入口
  ///
  /// 根据不同输入类型（手势/传感器）动态切换优先级，
  /// 并处理输入冲突、状态切换等。
  ///
  /// - [tiltStreamModel]：当前输入 [TiltStreamModel]
  /// - [deviceOrientation]：当前设备方向
  ///
  /// @return [TiltStreamModel]
  TiltStreamModel resolve(
    TiltStreamModel tiltStreamModel, {
    required DeviceOrientation deviceOrientation,
  }) {
    switch (tiltStreamModel.gesturesType) {
      case GesturesType.none:
        break;
      case GesturesType.touch || GesturesType.hover || GesturesType.controller:
        {
          if (latestTiltStreamModel == tiltStreamModel) {
            return tiltStreamModel;
          }

          final isHighPriority = compareGesturesTypePriority(
                tiltStreamModel.gesturesType,
                latestTiltStreamModel.gesturesType,
              ) ==
              tiltStreamModel.gesturesType;

          /// 若为高优先级或当前无激活输入，则切换为当前输入
          if (isHighPriority || !latestTiltStreamModel.isActive) {
            latestTiltStreamModel = tiltStreamModel;
          }

          /// 手势结束后，允许传感器输入重新生效
          if (!tiltStreamModel.isActive) {
            _handleGesturesConflict(tiltStreamModel.gesturesType);
            _enableSensors = true;
          } else {
            _enableSensors = false;
          }
        }
      case GesturesType.sensors:
        {
          /// 仅在允许传感器输入且无手势冲突时，更新传感器输入
          if (_enableSensors && _gesturesHarmonizerTimer == null) {
            _updateSensorsTiltPosition(tiltStreamModel, deviceOrientation);
          }
        }
    }

    return latestTiltStreamModel;
  }

  /// 判断两个输入类型的优先级，返回优先级更高的类型
  GesturesType compareGesturesTypePriority(
    GesturesType gesturesType1,
    GesturesType gesturesType2,
  ) {
    if (gesturesType1 == gesturesType2) return gesturesType1;

    final gesturePriority = <GesturesType>[
      GesturesType.touch, // 最高优先级
      GesturesType.hover,
      GesturesType.controller,
      GesturesType.sensors, // 最低优先级
      GesturesType.none,
    ];
    return gesturePriority.indexOf(gesturesType1) <
            gesturePriority.indexOf(gesturesType2)
        ? gesturesType1
        : gesturesType2;
  }

  /// 根据设备方向修正传感器输入的坐标，并更新最新输入流
  void _updateSensorsTiltPosition(
    TiltStreamModel tiltStreamModel,
    DeviceOrientation deviceOrientation,
  ) {
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
      isActive: true,
    );
  }

  /// 处理手势输入结束后的冲突
  void _handleGesturesConflict(GesturesType gesturesType) {
    final duration = switch (gesturesType) {
      GesturesType.touch || GesturesType.hover => tiltConfig.leaveDuration,
      GesturesType.controller => tiltConfig.controllerLeaveDuration,
      _ => null,
    };
    if (duration != null) {
      _startGesturesHarmonizer(duration);
    }
  }

  /// 启动手势冲突协调定时器，定时结束后允许传感器输入
  void _startGesturesHarmonizer(Duration duration) {
    if (_gesturesHarmonizerTimer != null) return;
    _gesturesHarmonizerTimer?.cancel();
    _gesturesHarmonizerTimer = async.Timer(
      duration,
      () => _gesturesHarmonizerTimer = null,
    );
  }
}
