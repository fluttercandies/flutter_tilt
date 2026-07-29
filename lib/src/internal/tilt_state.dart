import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import '../config/tilt_config.dart';
import '../enums.dart';
import '../models/tilt_data_model.dart';
import '../utils/utils.dart';

/// 倾斜状态
@immutable
class TiltState {
  /// 倾斜状态
  const TiltState({
    required this.isInit,
    required this.tiltConfig,
    required this.width,
    required this.height,
    required this.areaProgress,
    required this.isActive,
    required this.currentGesturesType,
  });

  /// 是否初始化
  final bool isInit;

  /// 倾斜配置
  final TiltConfig tiltConfig;

  /// 尺寸 width
  final double width;

  /// 尺寸 height
  final double height;

  /// Progress value for the tilt effect in the widget area.
  ///
  /// widget 区域内倾斜效果的进度值。
  ///
  /// {@macro tilt.TiltDataModel.areaProgress.en}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltDataModel.areaProgress.zh}
  final Offset areaProgress;

  /// {@macro tilt.TiltStreamModel.isActive.en}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltStreamModel.isActive.zh}
  final bool isActive;

  /// {@macro tilt.TiltStreamModel.gesturesType.en}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltStreamModel.gesturesType.zh}
  final GesturesType currentGesturesType;

  /// {@macro tilt.TiltDataModel.position.en}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltDataModel.position.zh}
  Offset get position => Utils.progressPosition(width, height, areaProgress);

  /// {@macro tilt.TiltDataModel.transform.en}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltDataModel.transform.zh}
  Matrix4 get transform =>
      isInit && !disable ? tiltTransform() : Matrix4.identity();

  /// The actual tilt angle
  ///
  /// 实际倾斜旋转角度
  ///
  /// {@macro tilt.TiltDataModel.angle.en}
  ///
  /// ------
  ///
  /// {@macro tilt.TiltDataModel.angle.zh}
  Offset get angle => Utils.rotateAxis(
        areaProgress * tiltConfig.angle,
        tiltConfig.enableReverse,
      );

  /// 禁用
  bool get disable => tiltConfig.disable;

  TiltState copyWith({
    bool? isInit,
    TiltConfig? tiltConfig,
    double? width,
    double? height,
    Offset? areaProgress,
    bool? isActive,
    GesturesType? currentGesturesType,
  }) {
    return TiltState(
      isInit: isInit ?? this.isInit,
      tiltConfig: tiltConfig ?? this.tiltConfig,
      width: width ?? this.width,
      height: height ?? this.height,
      areaProgress: areaProgress ?? this.areaProgress,
      isActive: isActive ?? this.isActive,
      currentGesturesType: currentGesturesType ?? this.currentGesturesType,
    );
  }

  /// 根据当前位置生成 “移动” 的下一份倾斜数据
  ///
  /// 仅负责纯数据转换，不处理节流、边界判断等
  TiltState moveTo(Offset position, GesturesType gesturesType) {
    return copyWith(
      areaProgress: Utils.p2cAreaProgress(
        width,
        height,
        position,
        tiltConfig.direction,
      ),
      isActive: true,
      currentGesturesType: gesturesType,
    );
  }

  /// 根据当前位置生成 “复原” 的下一份倾斜数据
  ///
  /// 仅负责纯数据转换，不决定是否应该执行复原
  TiltState revertTo(Offset position, GesturesType gesturesType) {
    return copyWith(
      areaProgress: Utils.p2cAreaProgress(
        width,
        height,
        position,
        tiltConfig.direction,
      ),
      isActive: false,
      currentGesturesType: gesturesType,
    );
  }

  /// 解析复原时应回到的目标坐标
  ///
  /// 当启用复原时，返回由初始区域进度推导出的初始坐标；
  /// 否则保持当前位置不变。
  Offset resolveRevertPosition({
    required Offset currentPosition,
    required Offset initialAreaProgress,
  }) {
    if (!tiltConfig.enableRevert) {
      return currentPosition;
    }
    return Utils.progressPosition(width, height, initialAreaProgress);
  }

  /// 计算当前坐标进度的倾斜
  Matrix4 tiltTransform() {
    return tiltTransformFor(areaProgress);
  }

  /// 计算指定区域进度的倾斜
  Matrix4 tiltTransformFor(Offset targetAreaProgress) {
    final config = tiltConfig;
    final rotate = Utils.rotateAxis(
      /// 旋转大小：区域进度 * 弧度
      targetAreaProgress * Utils.radian(config.angle),
      config.enableReverse,
    );
    final rotateX = rotate.dx, rotateY = rotate.dy;
    final maxSize = math.max<double>(width, height);

    // 透视强度，自定义原始值，未设置时按尺寸自适应（近大远小）
    final perspectiveIntensityValue =
        config.perspectiveIntensity ?? 0.5 / maxSize;

    // 旋转支点在 Z 方向的偏移量
    final zOffset = config.zOffset;

    return Matrix4.identity()
      // 透视：近大远小
      ..setEntry(3, 2, perspectiveIntensityValue)
      // 与后面的 zOffset 成对，把旋转轴心沿 Z 偏移（与后面的 zOffset 对消，不改变原始大小）
      // TODO: 兼容低版本开发者，未来完全弃用时再替换为新的方法（Flutter 3.35 开始标记为弃用）
      // ignore: deprecated_member_use
      ..translate(0.0, 0.0, -zOffset)
      // 倾斜：绕 X / Y 轴旋转
      ..rotateX(rotateX)
      ..rotateY(rotateY)
      // 与前面的 zOffset 成对，把轴心推回，绕 “Z 偏移支点” 旋转（纵深摆动）
      // TODO: 兼容低版本开发者，未来完全弃用时再替换为新的方法（Flutter 3.35 开始标记为弃用）
      // ignore: deprecated_member_use
      ..translate(0.0, 0.0, zOffset);
  }

  /// 转换为 TiltDataModel
  /// 仅包含当前状态的核心数据，供外部使用
  TiltDataModel toModel() => TiltDataModel(
        width: width,
        height: height,
        position: position,
        transform: transform,
        areaProgress: areaProgress,
        angle: angle,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TiltState &&
        isInit == other.isInit &&
        width == other.width &&
        height == other.height &&
        areaProgress == other.areaProgress &&
        isActive == other.isActive &&
        currentGesturesType == other.currentGesturesType &&
        tiltConfig == other.tiltConfig;
  }

  @override
  int get hashCode => Object.hash(
        isInit,
        width,
        height,
        areaProgress,
        isActive,
        currentGesturesType,
        tiltConfig,
      );
}
