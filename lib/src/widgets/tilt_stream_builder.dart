import 'package:flutter/widgets.dart';

import '../internal/controllers/tilt_gestures_controller.dart';
import '../models/tilt_stream_model.dart';

/// Tilt StreamBuilder
class TiltStreamBuilder extends StatefulWidget {
  /// Tilt StreamBuilder
  ///
  /// 手势相关输入操作
  const TiltStreamBuilder({
    super.key,
    required this.tiltGesturesController,
    required this.builder,
  });

  /// 倾斜手势控制器
  final TiltGesturesController tiltGesturesController;

  /// Stream builder
  final Widget Function(BuildContext, AsyncSnapshot<TiltStreamModel>) builder;

  @override
  State<TiltStreamBuilder> createState() => _TiltStreamBuilderState();
}

class _TiltStreamBuilderState extends State<TiltStreamBuilder> {
  TiltGesturesController get _tiltGesturesController =>
      widget.tiltGesturesController;
  Widget Function(BuildContext, AsyncSnapshot<TiltStreamModel>) get _builder =>
      widget.builder;

  @override
  void initState() {
    super.initState();
    _tiltGesturesController.initSensors(context);
  }

  @override
  void dispose() {
    _tiltGesturesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TiltStreamModel>(
      stream: _tiltGesturesController.tiltStream,
      initialData: _tiltGesturesController.initialTiltStreamModel,
      builder: _builder,
    );
  }
}
