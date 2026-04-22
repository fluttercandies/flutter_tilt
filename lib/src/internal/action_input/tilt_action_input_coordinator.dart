import 'package:flutter/widgets.dart';

import '../../config/tilt_config.dart';
import '../../controllers/tilt_controller.dart';
import '../../enums.dart';
import '../../models/tilt_stream_model.dart';
import 'sources/tilt_action_input_source.dart';
import 'sources/tilt_pointer_input_source.dart';
import 'sources/tilt_sensor_input_source.dart';
import 'tilt_action_input_resolver.dart';

/// 协调 Tilt 内部多种输入源（如手势、传感器），统一管理输入规则与生命周期
///
/// 职责：
/// - 统一管理手势、传感器等输入源的初始化与释放
/// - 负责输入流的优先级、冲突协调（委托给 [TiltActionInputResolver]）
/// - 提供输入 stream 的统一入口
class TiltActionInputCoordinator {
  TiltActionInputCoordinator({
    required this.tiltController,
    required this.disable,
    required this.fps,
    required this.tiltConfig,
    required this.initialPosition,
  }) : initialTiltStreamModel = TiltStreamModel(
          position: initialPosition,
          gesturesType: GesturesType.none,
        );

  /// Tilt 控制器，负责输入流的分发与管理
  final TiltController tiltController;

  /// 是否禁用输入流
  final bool disable;

  final int fps;
  final TiltConfig tiltConfig;

  /// 输入流初始位置
  final Offset initialPosition;

  /// 初始输入 [TiltStreamModel]
  final TiltStreamModel initialTiltStreamModel;

  /// 输入流优先级处理与冲突协调器
  late final TiltActionInputResolver _tiltActionInputResolver =
      TiltActionInputResolver(
    initialTiltStreamModel: initialTiltStreamModel,
    tiltConfig: tiltConfig,
  );

  /// 手势输入源（如指针、触摸等）
  late final TiltPointerInputSource pointerInputSource =
      TiltPointerInputSource(tiltController: tiltController);

  /// 传感器输入源（如陀螺仪等）
  late final TiltSensorInputSource _sensorInputSource = TiltSensorInputSource(
    tiltController: tiltController,
    disable: disable,
    fps: fps,
    tiltConfig: tiltConfig,
  );

  /// 所有输入源列表
  late final List<TiltActionInputSource> tiltActionInputSources = [
    pointerInputSource,
    _sensorInputSource,
  ];

  /// 输入流统一入口，自动处理优先级与冲突
  late final Stream<TiltStreamModel>? stream =
      enableTiltStream ? tiltController.stream.map(_filterTiltStream) : null;

  /// 是否启用输入流
  bool get enableTiltStream => !disable;

  void init(BuildContext context) {
    for (final inputSource in tiltActionInputSources) {
      inputSource.init(context);
    }
  }

  void dispose() {
    for (final inputSource in tiltActionInputSources) {
      inputSource.dispose();
    }
    disposeResolver();
  }

  /// 仅释放 [TiltActionInputResolver]
  void disposeResolver() {
    _tiltActionInputResolver.dispose();
  }

  /// 输入流优先级与冲突消解主入口
  TiltStreamModel _filterTiltStream(TiltStreamModel tiltStreamModel) {
    return _tiltActionInputResolver.resolve(
      tiltStreamModel,
      deviceOrientation: _sensorInputSource.deviceOrientation,
    );
  }
}
