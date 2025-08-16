import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/models/tilt_data_model.dart';

void main() {
  group('TiltDataModel ::', () {
    test('hashCode', () {
      final tiltDataModel = TiltDataModel(
        position: const Offset(5, 5),
        areaProgress: Offset.zero,
        transform: Matrix4.identity(),
        angle: Offset.zero,
      );
      final tiltDataModel2 = TiltDataModel(
        position: const Offset(5, 5),
        areaProgress: Offset.zero,
        transform: Matrix4.identity(),
        angle: Offset.zero,
      );
      expect(tiltDataModel, tiltDataModel2);
      expect(tiltDataModel.hashCode, tiltDataModel2.hashCode);
    });
  });
}
