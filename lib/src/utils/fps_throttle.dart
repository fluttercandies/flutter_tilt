import 'dart:async' as async show Timer;
import 'dart:math' as math;

Duration frameDurationFromFps(int fps) {
  if (fps <= 0) {
    throw RangeError.range(
      fps,
      1,
      null,
      'fps',
      'fps must be greater than 0.',
    );
  }

  return Duration(
    microseconds: math.max(1, Duration.microsecondsPerSecond ~/ fps),
  );
}

class FpsThrottle {
  FpsThrottle(this.fps) : frameDuration = frameDurationFromFps(fps);

  final int fps;
  final Duration frameDuration;

  /// FPS 计时器
  async.Timer? _fpsTimer;

  void dispose() {
    _fpsTimer?.cancel();
    _fpsTimer = null;
  }

  /// 判断是否可以触发下一帧
  bool shouldTrigger() {
    if (_fpsTimer == null) {
      _startTimer();
      return true;
    }
    return false;
  }

  /// 启动计时器
  void _startTimer() {
    _fpsTimer = async.Timer(
      frameDuration,
      () => _fpsTimer = null,
    );
  }
}
