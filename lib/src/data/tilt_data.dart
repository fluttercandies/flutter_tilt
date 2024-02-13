import 'package:flutter/widgets.dart';

import '../utils.dart';
import '../enums.dart';
import '../config/tilt_config.dart';

/// 倾斜数据
@immutable
class TiltData {
  /// 倾斜数据
  const TiltData({
    required this.isInit,
    required this.width,
    required this.height,
    required this.areaProgress,
    required this.tiltConfig,
  });

  /// 是否初始化
  final bool isInit;

  /// 尺寸 width
  final double width;

  /// 尺寸 height
  final double height;

  /// 区域进度
  final Offset areaProgress;

  /// 倾斜配置
  final TiltConfig tiltConfig;

  /// 倾斜数据
  TiltDataModel get data => TiltDataModel(
        position: position,
        transform: transform,
        areaProgress: areaProgress,
        angle: angle,
      );

  /// 当前坐标
  Offset get position => Utils.progressPosition(width, height, areaProgress);

  /// Transform
  Matrix4 get transform =>
      isInit && !disable ? tiltTransform() : Matrix4.identity();

  /// 实际旋转角度
  ///
  /// {@macro tilt.TiltDataModel.angle}
  Offset get angle => Utils.rotateAxis(
      areaProgress * tiltConfig.angle, tiltConfig.enableReverse);

  /// 禁用
  bool get disable => tiltConfig.disable;

  /// 计算当前坐标进度的倾斜
  Matrix4 tiltTransform() {
    /// 旋转大小：区域进度 * 弧度
    final Offset rotate = Utils.rotateAxis(
      areaProgress * Utils.radian(tiltConfig.angle),
      tiltConfig.enableReverse,
    );
    final double rotateX = rotate.dx, rotateY = rotate.dy;

    return Matrix4.identity()

      /// 近大远小效果（适配不同尺寸的组件）
      ..setEntry(3, 2, 0.5 / (width > height ? width : height))

      /// 旋转轴
      ..rotateX(rotateX)
      ..rotateY(rotateY);
  }
}

/// 倾斜数据
@immutable
class TiltDataModel {
  /// 倾斜数据
  const TiltDataModel({
    required this.position,
    required this.areaProgress,
    required this.transform,
    required this.angle,
  });

  /// 当前坐标
  final Offset position;

  /// 区域进度
  ///
  /// {@template tilt.TiltDataModel.areaProgress}
  /// 正常范围 (x, y)：(1, 1) 至 (-1, -1)
  ///
  /// 移动过程中的最大倾斜量按照 [TiltConfig.angle] 进行倾斜
  ///
  /// 例如：
  /// * (0, 0) 会保持平面
  /// * (1.0, 1.0) 倾斜左上角 [TiltConfig.angle] 最大角度
  /// * (-1.0, -1.0) 倾斜右下角 [TiltConfig.angle] 最大角度
  /// {@endtemplate}
  final Offset areaProgress;

  /// Transform
  final Matrix4 transform;

  /// 实际旋转角度
  ///
  /// {@template tilt.TiltDataModel.angle}
  /// 正常范围 (x, y)：(angle, -angle) 至 (-angle, angle)
  ///
  /// 移动过程中的最大倾斜量按照 [TiltConfig.angle] 进行倾斜
  ///
  /// 例如：
  /// * (0, 0) 会保持平面
  /// * (angle, -angle) 倾斜左上角 [TiltConfig.angle] 最大角度
  /// * (-angle, angle) 倾斜右下角 [TiltConfig.angle] 最大角度
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
        other.position == position &&
        other.areaProgress == areaProgress &&
        other.transform == transform &&
        other.angle == angle;
  }

  @override
  int get hashCode => Object.hash(
        position.hashCode,
        areaProgress.hashCode,
        transform.hashCode,
        angle.hashCode,
      );
}

/// 倾斜 Stream 数据
@immutable
class TiltStreamModel {
  const TiltStreamModel({
    required this.position,
    this.gesturesType = GesturesType.controller,
    this.gestureUse = true,
  });

  /// 当前触发的坐标位置
  ///
  /// 会触发对应位置的倾斜效果
  ///
  /// 比如：
  /// 组件尺寸 width: 10, height: 10，
  /// - [position] 为 (0, 0) 坐标时，会触发最左上的倾斜
  /// - [position] 为 (10, 10) 坐标时，会触发最右下的倾斜
  final Offset position;

  /// 触发手势类型
  ///
  /// 手势优先级：
  /// [GesturesType.touch] > [GesturesType.hover] > [GesturesType.controller] > [GesturesType.sensors]
  ///
  /// 如果需要使用动画或其他方式自行控制，
  ///
  /// *推荐* 使用 [GesturesType.controller]
  ///
  /// 如果使用其他的类型进行触发，
  /// 那么就会受到对应类型相关配置、效果的影响。
  ///
  /// 比如：
  /// 自行触发 [GesturesType.sensors] 的时候，
  /// 配置 [TiltConfig.enableSensorRevert] 为 false 的情况下，
  /// 将同样不会复原至初始状态。
  final GesturesType gesturesType;

  /// 手势是否正在使用
  ///
  /// 用于确定手势是否正在使用，
  /// 并根据手势优先级进行处理。
  ///
  /// 比如：
  /// 如果在触发 [GesturesType.touch] 的时候永远不赋值为 false，
  /// 那么优先级低于 [GesturesType.touch] 的手势将永远不会被触发。
  ///
  /// - [true]  手势正在使用
  /// - [false] 手势离开或不再使用
  final bool gestureUse;
}
