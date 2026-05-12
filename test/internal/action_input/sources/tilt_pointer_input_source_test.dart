import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/src/controllers/tilt_controller.dart';
import 'package:flutter_tilt/src/enums.dart';
import 'package:flutter_tilt/src/internal/action_input/sources/tilt_pointer_input_source.dart';
import 'package:flutter_tilt/src/models/tilt_stream_model.dart';

void main() {
  group('TiltPointerInputSource ::', () {
    late TiltController tiltController;
    late TiltPointerInputSource inputSource;

    setUp(() {
      tiltController = TiltController();
      inputSource = TiltPointerInputSource(
        tiltController: tiltController,
      );
    });

    tearDown(() {
      tiltController.dispose();
    });

    test('emits touch move and leave events', () async {
      final events = <TiltStreamModel>[];
      final subscription = tiltController.stream.listen(events.add);

      inputSource.handlePointerMove(
        const PointerMoveEvent(position: Offset(3, 4)),
      );
      inputSource.handlePointerUp(
        const PointerUpEvent(position: Offset(3, 4)),
      );

      await Future<void>.delayed(Duration.zero);

      expect(events, hasLength(2));
      expect(events.first.gesturesType, GesturesType.touch);
      expect(events.first.isActive, isTrue);
      expect(events.first.position, const Offset(3, 4));
      expect(events.last.gesturesType, GesturesType.touch);
      expect(events.last.isActive, isFalse);

      await subscription.cancel();
    });

    test('requires hover enter and blocks hover while touching', () async {
      final events = <TiltStreamModel>[];
      final subscription = tiltController.stream.listen(events.add);

      /// Hover events should be blocked until a hover enter is received
      inputSource.handleMouseHover(
        const PointerHoverEvent(position: Offset(1, 1)),
      );

      /// Hover enter, should be accepted
      inputSource.handleMouseEnter(
        const PointerEnterEvent(position: Offset(1, 1)),
      );

      /// Now hover events should be accepted
      inputSource.handleMouseHover(
        const PointerHoverEvent(position: Offset(2, 2)),
      );

      /// Touch events should still be accepted
      inputSource.handlePointerMove(
        const PointerMoveEvent(position: Offset(9, 9)),
      );

      /// While touching, hover should be blocked
      inputSource.handleMouseHover(
        const PointerHoverEvent(position: Offset(4, 4)),
      );

      /// Touch leave
      inputSource.handlePointerCancel(
        const PointerCancelEvent(position: Offset(9, 9)),
      );

      /// Now hover should be accepted again
      inputSource.handleMouseExit(
        const PointerExitEvent(position: Offset(2, 2)),
      );

      await Future<void>.delayed(Duration.zero);
      expect(events, hasLength(4));
      expect(events[0].gesturesType, GesturesType.hover);
      expect(events[0].isActive, isTrue);
      expect(events[0].position, const Offset(2, 2));
      expect(events[1].gesturesType, GesturesType.touch);
      expect(events[1].isActive, isTrue);
      expect(events[2].gesturesType, GesturesType.touch);
      expect(events[2].isActive, isFalse);
      expect(events[3].gesturesType, GesturesType.hover);
      expect(events[3].isActive, isFalse);

      await subscription.cancel();
    });
  });
}
