import 'dart:async' as async show StreamController;

import 'package:flutter/widgets.dart';

import '../enums.dart';
import '../models/tilt_stream_model.dart';

/// TiltController
class TiltController {
  /// Controls Tilt-related events (such as move/leave).
  ///
  /// Call [dispose] when no longer used.
  ///
  /// ------
  ///
  /// 用于控制 Tilt 相关事件（如 move/leave）。
  ///
  /// 不再使用时调用 [dispose] 释放资源。
  TiltController()
      : _streamController = async.StreamController<TiltStreamModel>.broadcast();

  final async.StreamController<TiltStreamModel> _streamController;

  Stream<TiltStreamModel> get stream => _streamController.stream;

  /// Whether there is a subscriber on the [Stream].
  ///
  /// ------
  ///
  /// [Stream] 上是否有订阅者。
  bool get hasListener => _streamController.hasListener;

  Future<void> dispose() async {
    await _streamController.close();
  }

  /// Emit a [TiltStreamModel] to the stream.
  ///
  /// ------
  ///
  /// 向 stream 发出一个 [TiltStreamModel]。
  void emit(TiltStreamModel tiltStreamModel) {
    _streamController.sink.add(tiltStreamModel);
  }

  /// Handle the "move" input event.
  ///
  /// Should be used together with [leave] to indicate the end of the gesture.
  ///
  ///
  /// [position]
  /// {@macro tilt.TiltStreamModel.position.en}
  ///
  /// [gesturesType]
  /// {@macro tilt.TiltStreamModel.gesturesType.en}
  ///
  /// ------
  ///
  /// 处理 "move" 输入事件。
  ///
  /// 应与 [leave] 配合使用以表示手势结束。
  ///
  /// [position]
  /// {@macro tilt.TiltStreamModel.position.zh}
  ///
  /// [gesturesType]
  /// {@macro tilt.TiltStreamModel.gesturesType.zh}
  void move({
    required Offset position,
    GesturesType gesturesType = GesturesType.controller,
  }) {
    emit(
      TiltStreamModel(
        position: position,
        gesturesType: gesturesType,
        isActive: true,
      ),
    );
  }

  /// Handle the "leave" input event.
  ///
  /// [position]
  /// {@macro tilt.TiltStreamModel.position.en}
  ///
  /// [gesturesType]
  /// {@macro tilt.TiltStreamModel.gesturesType.en}
  ///
  /// ------
  ///
  /// 处理 "leave" 输入事件。
  ///
  /// [position]
  /// {@macro tilt.TiltStreamModel.position.zh}
  ///
  /// [gesturesType]
  /// {@macro tilt.TiltStreamModel.gesturesType.zh}
  void leave({
    required Offset position,
    GesturesType gesturesType = GesturesType.controller,
  }) {
    emit(
      TiltStreamModel(
        position: position,
        gesturesType: gesturesType,
        isActive: false,
      ),
    );
  }
}
