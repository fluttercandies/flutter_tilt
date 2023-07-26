import 'dart:async' as async;
import 'package:flutter/widgets.dart';

import 'package:flutter_tilt/src/data/tilt_data.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/gestures_listener.dart';
import 'package:flutter_tilt/src/state/tilt_state.dart';
import 'package:flutter_tilt/src/tilt_container.dart';
import 'package:flutter_tilt/src/tilt_parallax_container.dart';
import 'package:flutter_tilt/src/type/tilt_light_type.dart';
import 'package:flutter_tilt/src/type/tilt_shadow_type.dart';
import 'package:flutter_tilt/src/type/tilt_type.dart';
import 'package:flutter_tilt/src/utils.dart';

/// 倾斜
class Tilt extends StatefulWidget {
  /// 倾斜
  ///
  /// 在 [childInner] 中使用 [TiltParallax] 可以达到视差的效果
  const Tilt({
    super.key,
    required this.child,
    this.childInner = const <Widget>[],
    this.disable = false,
    this.fps = 60,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.tiltConfig = const TiltConfig(),
    this.lightConfig = const LightConfig(),
    this.shadowConfig = const ShadowConfig(),
    this.onGestureMove,
    this.onGestureLeave,
  });

  /// 主 child
  final Widget child;

  /// 内部 child
  ///
  /// {@template tilt.childInner}
  /// 一般用作视差的 Widget
  ///
  /// 本身作为 [Stack]，可以搭配 [Stack] 相关布局，
  /// {@endtemplate}
  final List<Widget> childInner;

  /// 全部禁用
  final bool disable;

  /// FPS
  ///
  /// 每秒手势触发帧数，帧数越高越平滑，但性能消耗越高。
  ///
  /// 推荐 60 FPS，如果遭遇性能问题，还可以使用人眼能够接受的 24 FPS
  final int fps;

  /// BorderRadius
  final BorderRadiusGeometry? borderRadius;

  /// Clip
  final Clip clipBehavior;

  /// 倾斜配置
  final TiltConfig tiltConfig;

  /// 光源配置
  final LightConfig lightConfig;

  /// 阴影配置
  final ShadowConfig shadowConfig;

  /// 手势移动触发
  final TiltCallback? onGestureMove;

  /// 手势离开触发
  final TiltCallback? onGestureLeave;

  @override
  State<Tilt> createState() => _TiltState();
}

class _TiltState extends State<Tilt> {
  Widget get _child => widget.child;
  List<Widget> get _childInner => widget.childInner;
  bool get _disable => widget.disable;
  int get _fps => widget.fps;
  BorderRadiusGeometry? get _borderRadius => widget.borderRadius;
  Clip get _clipBehavior => widget.clipBehavior;
  TiltConfig get _tiltConfig => widget.tiltConfig;
  LightConfig get _lightConfig => widget.lightConfig;
  ShadowConfig get _shadowConfig => widget.shadowConfig;
  TiltCallback? get _onGestureMove => widget.onGestureMove;
  TiltCallback? get _onGestureLeave => widget.onGestureLeave;

  /// 初始坐标区域进度
  Offset get _initAreaProgress => _tiltConfig.initial ?? Offset.zero;

  /// 是否初始化
  late bool isInit = false;
  late double width = 0.0, height = 0.0;

  /// 当前坐标的区域进度
  late Offset areaProgress = _initAreaProgress;

  /// 是否正在移动
  late bool isMove = false;

  /// FPS 计时器
  async.Timer? _fpsTimer;

  @override
  Widget build(BuildContext context) {
    return TiltState(
      isInit: isInit,
      width: width,
      height: height,
      areaProgress: areaProgress,
      isMove: isMove,
      onMove: onGesturesMove,
      onRevert: onGesturesRevert,
      onResize: onResize,
      child: GesturesListener(
        tiltConfig: _tiltConfig,
        child: TiltContainer(
          borderRadius: _borderRadius,
          clipBehavior: _clipBehavior,
          tiltConfig: _tiltConfig,
          lightConfig: _lightConfig,
          shadowConfig: _shadowConfig,
          childInner: _childInner,
          child: _child,
        ),
      ),
    );
  }

  /// 调整尺寸
  void onResize(Size size) {
    if (isInit) {
      return;
    }
    setState(() {
      isInit = true;
      width = size.width;
      height = size.height;
    });
  }

  /// 手势移动触发
  ///
  /// [offset] 当前坐标
  void onGesturesMove(Offset offset, GesturesType gesturesType) {
    if (!isInit || _disable) {
      return;
    }
    if (!fpsTimer()) {
      return;
    }
    if (_tiltConfig.enableOutsideAreaMove || isInRange(width, height, offset)) {
      setState(() {
        areaProgress = p2cAreaProgress(
          width,
          height,
          offset,
          _tiltConfig.direction,
        );
        isMove = true;
      });

      if (_onGestureMove != null) {
        _onGestureMove!(
          TiltData(
            isInit: isInit,
            width: width,
            height: height,
            areaProgress: areaProgress,
            tiltConfig: _tiltConfig,
          ).data,
          gesturesType,
        );
      }
    } else {
      onGesturesRevert(offset, gesturesType);
    }
  }

  /// 手势复原触发
  ///
  /// [offset] 当前坐标
  void onGesturesRevert(Offset offset, GesturesType gesturesType) {
    if (!isInit || _disable) {
      return;
    }

    /// 是否还原的取值
    final Offset position = _tiltConfig.enableRevert
        ? progressPosition(width, height, _initAreaProgress)
        : offset;

    setState(() {
      areaProgress = p2cAreaProgress(
        width,
        height,
        position,
        _tiltConfig.direction,
      );
      isMove = false;
    });

    if (_onGestureLeave != null) {
      _onGestureLeave!(
        TiltData(
          isInit: isInit,
          width: width,
          height: height,
          areaProgress: areaProgress,
          tiltConfig: _tiltConfig,
        ).data,
        gesturesType,
      );
    }
  }

  /// FPS
  bool fpsTimer() {
    if (_fpsTimer == null) {
      _fpsTimer = async.Timer(
        Duration(milliseconds: (1 / _fps * 1000) ~/ 1),
        () => _fpsTimer = null,
      );
      return true;
    } else {
      return false;
    }
  }
}

/// 倾斜视差
class TiltParallax extends StatelessWidget {
  /// 倾斜视差
  ///
  /// 一般用作视差的 Widget
  ///
  /// 只能在 [Tilt.childInner] 中使用
  const TiltParallax({
    super.key,
    required this.child,
    this.size = const Offset(10.0, 10.0),
    this.filterQuality = FilterQuality.high,
  });
  final Widget child;

  /// 视差大小 (x, y)
  final Offset size;

  final FilterQuality filterQuality;
  @override
  Widget build(BuildContext context) {
    return TiltParallaxContainer(
      size: size,
      filterQuality: filterQuality,
      child: child,
    );
  }
}
