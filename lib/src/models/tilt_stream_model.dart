import 'package:flutter/widgets.dart';
import '../enums.dart';

/// TiltStreamModel
/// 倾斜 Stream 数据 Model
@immutable
class TiltStreamModel {
  /// TiltStreamModel
  /// 倾斜 Stream 数据 Model
  const TiltStreamModel({
    required this.position,
    this.gesturesType = GesturesType.controller,
    this.isActive = true,
  });

  /// {@template tilt.TiltStreamModel.position.en}
  /// The current trigger position,
  /// It will have the tilt effect of the corresponding position.
  ///
  /// e.g.
  /// There is a widget size, width: 10, height: 10,
  /// - (0, 0): Maximum tilt top left.
  /// - (10, 10): Maximum tilt bottom right.
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltStreamModel.position.zh}
  /// 当前触发的坐标位置，
  /// 会触发对应位置的倾斜效果。
  ///
  /// 例如：
  /// 有一个 widget 尺寸为 width: 10, height: 10,
  /// - (0, 0)：会触发最左上的倾斜。
  /// - (10, 10)：会触发最右下的倾斜。
  /// {@endtemplate}
  final Offset position;

  /// {@template tilt.TiltStreamModel.gesturesType.en}
  /// Trigger gesture type.
  ///
  /// It is triggered according to the `gesture priority` of [GesturesType].
  ///
  /// If you need to customize the control with animation or other means.
  ///
  /// `Recommended` use of `GesturesType.controller`.
  ///
  /// If other types are used for triggering,
  /// Then it will be affected by the configuration and effects associated with that type.
  ///
  /// e.g.
  /// When custom triggering `GesturesType.sensors`.
  ///
  /// If `TiltConfig.enableSensorRevert` is configured to be false,
  /// it will also not revert to the initial state.
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltStreamModel.gesturesType.zh}
  /// 触发手势类型。
  ///
  /// 会根据 [GesturesType] 的 `手势优先级` 进行触发。
  ///
  /// 如果需要自定义动画或其他方式自行控制，
  ///
  /// `推荐` 使用 `GesturesType.controller`。
  ///
  /// 如果使用其他的类型进行触发，
  /// 那么就会受到对应类型相关配置、效果的影响。
  ///
  /// 例如：
  /// 自行触发 `GesturesType.sensors` 的时候。
  ///
  /// 配置 `TiltConfig.enableSensorRevert` 为 false 的情况下，
  /// 将同样不会复原至初始状态。
  /// {@endtemplate}
  final GesturesType gesturesType;

  /// Whether the gesture is currently active.
  ///
  /// Indicates whether the gesture is currently active,
  /// and is used to determine processing based on gesture priority.
  ///
  /// Gesture Priority:
  /// {@macro tilt.GesturesType.gesturePriority}
  ///
  /// e.g.
  /// If [GesturesType.touch] is never set to false when triggered,
  /// gestures with a lower priority than [GesturesType.touch] will never be triggered.
  ///
  /// - true: Gesture is active.
  /// - false: Gesture has ended or is no longer active.
  ///
  /// ------
  ///
  /// 手势当前是否处于活动状态。
  ///
  /// 表明手势当前是否处于活动状态，
  /// 并根据手势优先级进行处理判断。
  ///
  /// 手势优先级：
  /// {@macro tilt.GesturesType.gesturePriority}
  ///
  /// 例如：
  /// 如果在触发 [GesturesType.touch] 的时候永远不赋值为 false，
  /// 那么优先级低于 [GesturesType.touch] 的手势将永远不会被触发。
  ///
  /// - true：手势处于活动状态。
  /// - false：手势已结束或不再处于活动状态。
  final bool isActive;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TiltStreamModel &&
        other.position == position &&
        other.gesturesType == gesturesType &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(
        position.hashCode,
        gesturesType.hashCode,
        isActive.hashCode,
      );
}
