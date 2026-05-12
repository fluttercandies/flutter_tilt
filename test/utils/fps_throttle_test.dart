import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/utils/fps_throttle.dart';

void main() {
  group('FpsThrottle ::', () {
    test('uses microsecond precision for frame duration', () {
      expect(
        frameDurationFromFps(120),
        const Duration(microseconds: 8333),
      );
      expect(
        frameDurationFromFps(60),
        const Duration(microseconds: 16666),
      );
    });

    test('throws a RangeError for non-positive fps', () {
      expect(() => frameDurationFromFps(0), throwsRangeError);
      expect(() => frameDurationFromFps(-1), throwsRangeError);
      expect(() => FpsThrottle(0), throwsRangeError);
    });
  });
}
