import 'package:flutter/widgets.dart';

/// 倾斜手势移动回调
///
/// [position] 当前坐标
typedef TiltGestureMoveCallback = void Function(Offset position);

/// 倾斜手势离开回调
///
/// [position] 当前坐标
typedef TiltGestureLeaveCallback = void Function(Offset position);
