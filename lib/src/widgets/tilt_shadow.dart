import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

import '../config/tilt_light_config.dart';
import '../config/tilt_shadow_config.dart';
import '../enums.dart';
import '../internal/mixin/tilt_decoration_mixin.dart';
import '../utils.dart';

abstract class TiltShadow extends StatelessWidget with TiltDecorationMixin {
  const TiltShadow({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.areaProgress,
    required this.lightConfig,
    required this.shadowConfig,
  });

  final Widget child;
  final double width, height;

  /// 当前坐标的区域进度
  final Offset areaProgress;

  /// 光源配置
  final LightConfig lightConfig;

  /// 阴影配置
  final ShadowConfig shadowConfig;

  /// 阴影显示（受光源影响）
  ///
  /// 用于阴影颜色，限制最大进度表示强度（透明度）
  ///
  /// {@macro tilt.ShadowConfig.direction}
  double get showShadow {
    final direction =
        (shadowConfig.direction ?? lightConfig.direction) as Direction;
    return tiltDecorationDirectionProgress(
      areaProgress,
      direction,
      min: shadowConfig.minIntensity,
      max: shadowConfig.maxIntensity,
    );
  }

  /// 开启反向（受光源影响）
  ///
  /// {@macro tilt.ShadowConfig.enableReverse}
  bool get enableReverse =>
      shadowConfig.enableReverse ??
      (shadowConfig.direction == null && (lightConfig.enableReverse == true));

  /// 禁用阴影
  bool get shadowDisable =>
      shadowConfig.disable ||
      shadowConfig.maxIntensity == 0.0 ||
      shadowConfig.direction == ShadowDirection.none;

  /// 当前坐标的区域进度
  Offset get progress => -areaProgress;

  /// 距离中心的进度
  double get centerProgress => Utils.p2pDistance(Offset.zero, progress);

  /// 距离中心的进度最大值
  double get centerMaxProgress => math.max(1.0, centerProgress);

  /// 阴影当前偏移距离
  ///
  /// 阴影进度 * 阴影偏移系数的距离（相对当前尺寸的中心）
  Offset get baseOffset =>
      progress *
      Utils.p2pDistance(
        Utils.centerPosition(width, height),
        Utils.centerPosition(width, height) * (shadowConfig.offsetFactor + 1.0),
      );

  /// 阴影偏移
  Offset get offset =>
      (enableReverse ? -baseOffset : baseOffset) - shadowConfig.offsetInitial;
}

/// 阴影 Base
/// [LightShadowMode.base]
class TiltShadowBase extends TiltShadow {
  /// 阴影 Base
  ///
  /// 作用于其他组件上的阴影效果
  ///
  /// [width], [height] 一般和传入的组件尺寸一致
  ///
  /// {@macro tilt.ShadowConfig}
  const TiltShadowBase({
    super.key,
    required super.child,
    required super.width,
    required super.height,
    required super.areaProgress,
    required super.lightConfig,
    required super.shadowConfig,
    this.border,
    this.borderRadius,
    required this.clipBehavior,
  });

  /// Border
  final BoxBorder? border;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// Clip
  final Clip clipBehavior;

  /// 阴影模糊半径进度
  ///
  /// 距离中心的进度 * 最大模糊半径
  double get blurRadiusProgress =>
      centerMaxProgress * shadowConfig.maxBlurRadius;

  /// 阴影模糊半径
  double get blurRadius => math.max(
        blurRadiusProgress,
        shadowConfig.minBlurRadius,
      );

  /// 阴影扩散半径距离
  ///
  /// (距离中心的进度 * 阴影扩散系数)
  double get spreadRadiusDistance => Utils.p2pDistance(
        Offset(width, height),
        Offset(width, height) * (shadowConfig.spreadFactor + 1.0),
      );

  /// 阴影扩散半径距离还原
  ///
  /// 避免初始状态的扩散
  ///
  /// (阴影扩散半径距离 + 初始固定扩散值，随进度还原至 0)
  double get spreadRadiusRevert =>
      (spreadRadiusDistance + (math.min(width, height) / 10.0)) *
      (1 - centerMaxProgress);

  /// 阴影扩散半径
  ///
  /// 阴影扩散半径距离 - 阴影扩散半径距离还原 + 起始扩散半径
  double get spreadRadius =>
      spreadRadiusDistance - spreadRadiusRevert + shadowConfig.spreadInitial;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          if (!shadowDisable)
            BoxShadow(
              /// TODO: Flutter v3.27.0 之后需要迁移，在这之前暂时使用 withAlpha，
              /// （目前为了兼容更多低版本 Flutter 以及对于非主要 Tilt 效果的 P3 广色域优先级很低，未来再迁移为 withValues）
              /// 以下 withAlpha 内的计算方式和 withOpacity 内部的计算方式一致，
              /// 所以还不支持 P3 广色域，目前依旧是 sRGB。
              /// https://docs.flutter.dev/release/breaking-changes/wide-gamut-framework
              color: shadowConfig.color.withAlpha((255.0 * showShadow).round()),
              offset: offset,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
              blurStyle: BlurStyle.normal,
            ),
        ],
        border: border,
        borderRadius: borderRadius,
      ),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

/// 阴影 Projector
/// [LightShadowMode.projector]
class TiltShadowProjector extends TiltShadow {
  /// 阴影 Projector
  ///
  /// 作用于其他组件上的阴影效果
  ///
  /// [width], [height] 一般和传入的组件尺寸一致
  ///
  /// {@macro tilt.ShadowConfig}
  const TiltShadowProjector({
    super.key,
    required super.child,
    required super.width,
    required super.height,
    required super.areaProgress,
    required super.lightConfig,
    required super.shadowConfig,
  });

  /// 阴影尺寸比例
  double get scale => _calculateLerp(
        shadowConfig.projectorScaleFrom,
        shadowConfig.projectorScaleTo,
        centerMaxProgress,
      );

  /// 阴影模糊 Sigma
  double get blurSigma => _calculateLerp(
        shadowConfig.projectorBlurSigmaFrom,
        shadowConfig.projectorBlurSigmaTo,
        centerMaxProgress,
      );

  Matrix4 get transform => Matrix4.zero()
    ..setIdentity()
    ..translate(offset.dx, offset.dy)
    ..scale(scale, scale);

  @override
  Widget build(BuildContext context) {
    if (shadowDisable) return const SizedBox();

    /// TODO: BUG - 在 Web 端，Widget 嵌套顺序不同会导致渲染错误的奇怪效果，暂时单独处理。
    /// 目前测试下来是将 ImageFiltered 嵌套在 Transform 内引起的。
    if (kIsWeb) {
      return IgnorePointer(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
            tileMode: TileMode.decal,
          ),
          child: Opacity(
            opacity: showShadow,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                shadowConfig.color,
                BlendMode.srcATop,
              ),
              child: Transform(
                alignment: Alignment.center,
                transform: transform,
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    /// TODO: BUG - 在其他端，Widget 嵌套顺序不同会导致渲染错误的奇怪效果。
    /// 请暂时务必只保持以下嵌套顺序
    return IgnorePointer(
      child: Transform(
        alignment: Alignment.center,
        transform: transform,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            shadowConfig.color,
            BlendMode.srcATop,
          ),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurSigma,
              sigmaY: blurSigma,
              tileMode: TileMode.decal,
            ),
            child: Opacity(
              opacity: showShadow,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  /// 计算插值
  ///
  /// - [from] 起始值
  /// - [to] 目标值
  /// - [progress] 当前进度 (0.0 ~ 1.0)
  double _calculateLerp(double from, double to, double progress) {
    return lerpDouble(from, to, progress) ?? 0.0;
  }
}
