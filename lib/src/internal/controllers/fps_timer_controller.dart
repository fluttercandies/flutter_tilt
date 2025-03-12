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

  bool pass() {
    if (_fpsTimer == null) {
      _fpsTimer = async.Timer(
        Duration(milliseconds: (1000 / fps) ~/ 1),
        () => _fpsTimer = null,
      );
      return true;
    } else {
      return false;
    }
  }
}
