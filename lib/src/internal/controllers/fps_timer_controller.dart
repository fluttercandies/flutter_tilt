import 'dart:async' as async show Timer;

class FpsTimerController {
  FpsTimerController(this.fps);

  final int fps;

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
      Duration(milliseconds: (1000 / fps) ~/ 1),
      () => _fpsTimer = null,
    );
  }
}
