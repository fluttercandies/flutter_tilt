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
    this.gestureUse = true,
  });

  /// The current trigger position,
  /// It will have the tilt effect of the corresponding position.
  ///
  /// e.g.
  /// There is a widget size, width: 10, height: 10,
  /// - (0, 0): Maximum tilt top left.
  /// - (10, 10): Maximum tilt bottom right.
  ///
  /// ------
  ///
  /// 当前触发的坐标位置，
  /// 会触发对应位置的倾斜效果。
  ///
  /// 例如：
  /// 有一个组件尺寸为 width: 10, height: 10,
  /// - (0, 0)：会触发最左上的倾斜。
  /// - (10, 10)：会触发最右下的倾斜。
  ///
  final Offset position;

  /// Trigger gesture type.
  ///
  /// It is triggered according to the `gesture priority`.
  ///
  /// Gesture Priority:
  /// {@macro tilt.GesturesType.gesturePriority}
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
  ///
  /// ------
  ///
  /// 触发手势类型。
  ///
  /// 会根据 `手势优先级` 进行触发。
  ///
  /// 手势优先级：
  /// {@macro tilt.GesturesType.gesturePriority}
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
  ///
  final GesturesType gesturesType;

  /// Whether the gesture is being used.
  ///
  /// It is used to determine if the gesture is being used and
  /// will be processed according to the gesture priority.
  ///
  /// Gesture Priority:
  /// {@macro tilt.GesturesType.gesturePriority}
  ///
  /// e.g.
  /// If [GesturesType.touch] is never assigned false when triggered,
  /// gestures with a lower priority than [GesturesType.touch] will never be triggered.
  ///
  /// - true : Gesture being used.
  /// - false : Gestures to leave or no longer be used.
  ///
  /// ------
  ///
  /// 手势是否正在使用。
  ///
  /// 用于确定手势是否正在使用，并根据手势优先级进行处理。
  ///
  /// 手势优先级：
  /// {@macro tilt.GesturesType.gesturePriority}
  ///
  /// 例如：
  /// 如果在触发 [GesturesType.touch] 的时候永远不赋值为 false，
  /// 那么优先级低于 [GesturesType.touch] 的手势将永远不会被触发。
  ///
  /// - true : 手势正在使用。
  /// - false : 手势离开或不再使用。
  ///
  final bool gestureUse;

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
        other.gestureUse == gestureUse;
  }

  @override
  int get hashCode => Object.hash(
        position.hashCode,
        gesturesType.hashCode,
        gestureUse.hashCode,
      );
}
