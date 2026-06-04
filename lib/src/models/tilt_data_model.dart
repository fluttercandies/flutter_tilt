import 'package:flutter/widgets.dart';

/// TiltDataModel
/// 倾斜数据 Model
@immutable
class TiltDataModel {
  /// TiltDataModel
  /// 倾斜数据 Model
  const TiltDataModel({
    required this.width,
    required this.height,
    required this.position,
    required this.areaProgress,
    required this.transform,
    required this.angle,
  });

  /// The width of the Tilt widget.
  ///
  /// ------
  ///
  /// 倾斜 widget 的宽度。
  final double width;

  /// The height of the Tilt widget.
  ///
  /// ------
  ///
  /// 倾斜 widget 的高度。
  final double height;

  /// {@template tilt.TiltDataModel.position.en}
  /// The current pointer position that triggers the tilt effect.
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltDataModel.position.zh}
  /// 当前指针坐标位置（触发倾斜的坐标位置）。
  /// {@endtemplate}
  final Offset position;

  /// Progress value for the tilt effect in the widget area.
  ///
  /// widget 区域内倾斜效果的进度值。
  ///
  /// {@template tilt.TiltDataModel.areaProgress.en}
  /// Range (x, y): (1, 1) to (-1, -1)
  ///
  /// The maximum tilt during movement is tilted according to [TiltConfig.angle].
  ///
  /// For example:
  ///
  /// - (0, 0) will keep the plane
  /// - (1.0, 1.0) tilts the top left to the maximum angle of [TiltConfig.angle]
  /// - (-1.0, -1.0) tilts the bottom right to the maximum angle of [TiltConfig.angle]
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltDataModel.areaProgress.zh}
  /// 正常范围 (x, y)：(1, 1) 至 (-1, -1)
  ///
  /// 移动过程中的最大倾斜量按照 [TiltConfig.angle] 进行倾斜
  ///
  /// 例如：
  /// - (0, 0) 会保持平面
  /// - (1.0, 1.0) 倾斜左上角 [TiltConfig.angle] 最大角度
  /// - (-1.0, -1.0) 倾斜右下角 [TiltConfig.angle] 最大角度
  /// {@endtemplate}
  final Offset areaProgress;

  /// {@template tilt.TiltDataModel.transform.en}
  /// Tilt's built-in transform can be used with the Transform widget.
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltDataModel.transform.zh}
  /// Tilt 内置的 transform 可以配合 Transform widget 使用。
  /// {@endtemplate}
  final Matrix4 transform;

  /// The actual tilt angle
  ///
  /// 实际倾斜旋转角度
  ///
  /// {@template tilt.TiltDataModel.angle.en}
  /// Range (x, y): (angle, -angle) to (-angle, angle)
  ///
  /// The maximum tilt during movement is tilted according to [TiltConfig.angle].
  ///
  /// For example:
  /// - (0, 0) will keep the plane
  /// - (angle, -angle) tilts the top left to the maximum angle of [TiltConfig.angle]
  /// - (-angle, angle) tilts the bottom right to the maximum angle of [TiltConfig.angle]
  /// {@endtemplate}
  ///
  /// ------
  ///
  /// {@template tilt.TiltDataModel.angle.zh}
  /// 正常范围 (x, y)：(angle, -angle) 至 (-angle, angle)
  ///
  /// 移动过程中的最大倾斜量按照 [TiltConfig.angle] 进行倾斜
  ///
  /// 例如：
  /// - (0, 0) 会保持平面
  /// - (angle, -angle) 倾斜左上角 [TiltConfig.angle] 最大角度
  /// - (-angle, angle) 倾斜右下角 [TiltConfig.angle] 最大角度
  /// {@endtemplate}
  final Offset angle;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TiltDataModel &&
        other.width == width &&
        other.height == height &&
        other.position == position &&
        other.areaProgress == areaProgress &&
        other.transform == transform &&
        other.angle == angle;
  }

  @override
  int get hashCode => Object.hash(
        width,
        height,
        position,
        areaProgress,
        transform,
        angle,
      );
}
