import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/models/tilt_stream_model.dart';

void main() {
  group('TiltStreamModel ::', () {
    test('hashCode', () {
      const tiltStreamModel = TiltStreamModel(
        position: Offset(5, 5),
        gesturesType: GesturesType.controller,
        gestureUse: true,
      );
      const tiltStreamModel2 = TiltStreamModel(
        position: Offset(5, 5),
        gesturesType: GesturesType.controller,
        gestureUse: true,
      );
      expect(tiltStreamModel, tiltStreamModel2);
      expect(tiltStreamModel.hashCode, tiltStreamModel2.hashCode);
    });
  });
}
