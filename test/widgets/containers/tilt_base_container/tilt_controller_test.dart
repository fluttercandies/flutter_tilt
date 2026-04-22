import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

import '../../shared_widgets/tilt_base_container_widget.dart';

void main() {
  final childFinder = find.text('Tilt');

  group('TiltBaseContainer :: tilt TiltController ::', () {
    testWidgets('controller stream listen', (WidgetTester tester) async {
      var tiltStreamModelTest = const TiltStreamModel(
        position: Offset(1, 1),
        gesturesType: GesturesType.touch,
        isActive: false,
      );
      const tiltStreamModelExpect = TiltStreamModel(
        position: Offset.zero,
        gesturesType: GesturesType.controller,
      );

      final tiltController = TiltController();
      await tester.pumpWidget(
        TiltBaseContainerWidget(tiltController: tiltController),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(tiltStreamModelTest != tiltStreamModelExpect, true);

      tiltController.stream.listen((TiltStreamModel tiltStreamModel) {
        tiltStreamModelTest = tiltStreamModel;
      });
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();

      expect(tiltStreamModelTest, tiltStreamModelExpect);
      await tiltController.dispose();
    });

    testWidgets('disable all gestures and drive with controller', (
      WidgetTester tester,
    ) async {
      var tiltStreamModelTest = const TiltStreamModel(
        position: Offset(1, 1),
        gesturesType: GesturesType.controller,
        isActive: true,
      );
      var tiltStreamModelExpect = const TiltStreamModel(
        position: Offset.zero,
        gesturesType: GesturesType.controller,
        isActive: false,
      );
      TiltStreamModel? gestureMoveExpect;
      TiltStreamModel? gestureLeaveExpect;
      final tiltController = TiltController();

      await tester.pumpWidget(
        TiltBaseContainerWidget(
          tiltController: tiltController,
          tiltConfig: const TiltConfig(
            enableGestureTouch: false,
            enableGestureHover: false,
            enableGestureSensors: false,
          ),
          onGestureMove:
              (TiltDataModel tiltDataModel, GesturesType gesturesType) {
            gestureMoveExpect = TiltStreamModel(
              position: tiltDataModel.position,
              gesturesType: gesturesType,
              isActive: true,
            );
          },
          onGestureLeave: (
            TiltDataModel tiltDataModel,
            GesturesType gesturesType,
          ) {
            gestureLeaveExpect = TiltStreamModel(
              position: tiltDataModel.position,
              gesturesType: gesturesType,
              isActive: false,
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(tiltStreamModelTest != tiltStreamModelExpect, true);

      /// stream 监听
      tiltController.stream.listen((TiltStreamModel tiltStreamModel) {
        tiltStreamModelTest = tiltStreamModel;
      });

      /// controller touch 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.touch,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// controller touch 手势离开
      gestureLeaveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.touch,
        isActive: false,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(
        const TiltStreamModel(
          position: Offset(5, 5),
          gesturesType: GesturesType.touch,
          isActive: false,
        ),
        gestureLeaveExpect,
      );

      /// controller hover 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.hover,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// controller hover 手势离开
      gestureLeaveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.hover,
        isActive: false,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(
        gestureLeaveExpect,
        const TiltStreamModel(
          position: Offset(5, 5),
          gesturesType: GesturesType.hover,
          isActive: false,
        ),
      );

      /// controller controller 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.controller,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// controller controller 手势离开
      gestureLeaveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.controller,
        isActive: false,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(
        gestureLeaveExpect,
        const TiltStreamModel(
          position: Offset(5, 5),
          gesturesType: GesturesType.controller,
          isActive: false,
        ),
      );

      /// controller sensors 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.sensors,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// controller sensors 手势还原
      gestureLeaveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.sensors,
        isActive: false,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      // sensors 不会触发 onGestureLeave
      expect(gestureLeaveExpect, null);
      // 触发 sensors 为 0，让组件还原一点
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset.zero,
        gesturesType: GesturesType.sensors,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(
        gestureMoveExpect,
        const TiltStreamModel(
          position: Offset(9.75, 9.75),
          gesturesType: GesturesType.sensors,
          isActive: true,
        ),
      );

      await tiltController.dispose();
    });

    testWidgets('gesture priority', (WidgetTester tester) async {
      var tiltStreamModelTest = const TiltStreamModel(
        position: Offset(1, 1),
        gesturesType: GesturesType.controller,
        isActive: true,
      );
      var tiltStreamModelExpect = const TiltStreamModel(
        position: Offset.zero,
        gesturesType: GesturesType.controller,
        isActive: false,
      );
      TiltStreamModel? gestureMoveExpect;
      TiltStreamModel? gestureLeaveExpect;
      final tiltController = TiltController();

      await tester.pumpWidget(
        TiltBaseContainerWidget(
          tiltController: tiltController,
          onGestureMove:
              (TiltDataModel tiltDataModel, GesturesType gesturesType) {
            gestureMoveExpect = TiltStreamModel(
              position: tiltDataModel.position,
              gesturesType: gesturesType,
              isActive: true,
            );
          },
          onGestureLeave: (
            TiltDataModel tiltDataModel,
            GesturesType gesturesType,
          ) {
            gestureLeaveExpect = TiltStreamModel(
              position: tiltDataModel.position,
              gesturesType: gesturesType,
              isActive: false,
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(tiltStreamModelTest != tiltStreamModelExpect, true);

      /// stream 监听
      tiltController.stream.listen((TiltStreamModel tiltStreamModel) {
        tiltStreamModelTest = tiltStreamModel;
      });

      /// sensors 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.sensors,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// controller 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.controller,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// hover 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.hover,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// touch 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.touch,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// 低优先级判断
      const lowPriorityData = TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.touch,
        isActive: true,
      );

      /// hover 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.hover,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(gestureMoveExpect, lowPriorityData);

      /// touch 手势离开
      gestureMoveExpect = null;
      gestureLeaveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.touch,
        isActive: false,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(gestureMoveExpect, null);
      expect(
        gestureLeaveExpect,
        const TiltStreamModel(
          position: Offset(5, 5),
          gesturesType: GesturesType.touch,
          isActive: false,
        ),
      );

      /// hover 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.hover,
        isActive: true,
      );
      tiltController.emit(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      await tiltController.dispose();
    });
  });
}
