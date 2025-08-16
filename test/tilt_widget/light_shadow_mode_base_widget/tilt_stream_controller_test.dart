import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'tilt_widget_base.dart';

void main() {
  final childFinder = find.text('Tilt');
  group('LightShadowMode.base :: tilt TiltStreamController ::', () {
    testWidgets('stream listen', (WidgetTester tester) async {
      var tiltStreamModelTest = const TiltStreamModel(
        position: Offset(1, 1),
        gesturesType: GesturesType.touch,
        gestureUse: false,
      );
      const tiltStreamModelExpect = TiltStreamModel(
        position: Offset.zero,
        gesturesType: GesturesType.controller,
        gestureUse: true,
      );

      /// 基础
      final tiltStreamController =
          StreamController<TiltStreamModel>.broadcast();
      await tester.pumpWidget(
        TiltWidgetBase(tiltStreamController: tiltStreamController),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);

      /// 测试值不同
      expect(tiltStreamModelTest != tiltStreamModelExpect, true);

      await tester.pumpAndSettle();

      /// 监听
      tiltStreamController.stream.listen((TiltStreamModel tiltStreamModel) {
        tiltStreamModelTest = tiltStreamModel;
      });
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();

      /// 测试值相同
      expect(tiltStreamModelTest, tiltStreamModelExpect);
    });

    testWidgets('disable all gestures and use controller triggers', (
      WidgetTester tester,
    ) async {
      var tiltStreamModelTest = const TiltStreamModel(
        position: Offset(1, 1),
        gesturesType: GesturesType.controller,
        gestureUse: true,
      );
      var tiltStreamModelExpect = const TiltStreamModel(
        position: Offset.zero,
        gesturesType: GesturesType.controller,
        gestureUse: false,
      );
      TiltStreamModel? gestureMoveExpect;
      TiltStreamModel? gestureLeaveExpect;

      /// 基础 回调赋值
      final tiltStreamController =
          StreamController<TiltStreamModel>.broadcast();
      await tester.pumpWidget(
        TiltWidgetBase(
          tiltStreamController: tiltStreamController,
          tiltConfig: const TiltConfig(
            enableGestureTouch: false,
            enableGestureHover: false,
            enableGestureSensors: false,
          ),
          onGestureMove: (
            TiltDataModel tiltDataModel,
            GesturesType gesturesType,
          ) {
            gestureMoveExpect = TiltStreamModel(
              position: tiltDataModel.position,
              gesturesType: gesturesType,
              gestureUse: true,
            );
          },
          onGestureLeave: (
            TiltDataModel tiltDataModel,
            GesturesType gesturesType,
          ) {
            gestureLeaveExpect = TiltStreamModel(
              position: tiltDataModel.position,
              gesturesType: gesturesType,
              gestureUse: false,
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(tiltStreamModelTest != tiltStreamModelExpect, true);

      /// stream 监听
      tiltStreamController.stream.listen((TiltStreamModel tiltStreamModel) {
        tiltStreamModelTest = tiltStreamModel;
      });

      /// controller touch 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.touch,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// controller touch 手势离开
      gestureLeaveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.touch,
        gestureUse: false,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(
        const TiltStreamModel(
          position: Offset(5, 5),
          gesturesType: GesturesType.touch,
          gestureUse: false,
        ),
        gestureLeaveExpect,
      );

      /// controller hover 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.hover,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// controller hover 手势离开
      gestureLeaveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.hover,
        gestureUse: false,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(
        gestureLeaveExpect,
        const TiltStreamModel(
          position: Offset(5, 5),
          gesturesType: GesturesType.hover,
          gestureUse: false,
        ),
      );

      /// controller controller 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.controller,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// controller controller 手势离开
      gestureLeaveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.controller,
        gestureUse: false,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(
        gestureLeaveExpect,
        const TiltStreamModel(
          position: Offset(5, 5),
          gesturesType: GesturesType.controller,
          gestureUse: false,
        ),
      );

      /// controller sensors 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.sensors,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// controller sensors 手势还原
      gestureLeaveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.sensors,
        gestureUse: false,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      // sensors 不会触发 onGestureLeave
      expect(gestureLeaveExpect, null);
      // 触发 sensors 为 0，让组件还原一点
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset.zero,
        gesturesType: GesturesType.sensors,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(
        gestureMoveExpect,
        const TiltStreamModel(
          position: Offset(9.75, 9.75),
          gesturesType: GesturesType.sensors,
          gestureUse: true,
        ),
      );
    });

    testWidgets('gesture priority', (
      WidgetTester tester,
    ) async {
      var tiltStreamModelTest = const TiltStreamModel(
        position: Offset(1, 1),
        gesturesType: GesturesType.controller,
        gestureUse: true,
      );
      var tiltStreamModelExpect = const TiltStreamModel(
        position: Offset.zero,
        gesturesType: GesturesType.controller,
        gestureUse: false,
      );
      TiltStreamModel? gestureMoveExpect;
      TiltStreamModel? gestureLeaveExpect;

      /// 基础 回调赋值
      final tiltStreamController =
          StreamController<TiltStreamModel>.broadcast();
      await tester.pumpWidget(
        TiltWidgetBase(
          tiltStreamController: tiltStreamController,
          onGestureMove: (
            TiltDataModel tiltDataModel,
            GesturesType gesturesType,
          ) {
            gestureMoveExpect = TiltStreamModel(
              position: tiltDataModel.position,
              gesturesType: gesturesType,
              gestureUse: true,
            );
          },
          onGestureLeave: (
            TiltDataModel tiltDataModel,
            GesturesType gesturesType,
          ) {
            gestureLeaveExpect = TiltStreamModel(
              position: tiltDataModel.position,
              gesturesType: gesturesType,
              gestureUse: false,
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(childFinder, findsOneWidget);
      expect(tiltStreamModelTest != tiltStreamModelExpect, true);

      /// stream 监听
      tiltStreamController.stream.listen((TiltStreamModel tiltStreamModel) {
        tiltStreamModelTest = tiltStreamModel;
      });

      /// sensors 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.sensors,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// controller 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.controller,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// hover 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.hover,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// touch 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.touch,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);

      /// 低优先级判断
      const lowPriorityData = TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.touch,
        gestureUse: true,
      );

      /// hover 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.hover,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(gestureMoveExpect, lowPriorityData);

      /// touch 手势离开
      gestureMoveExpect = null;
      gestureLeaveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.touch,
        gestureUse: false,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(gestureMoveExpect, null);
      expect(
        gestureLeaveExpect,
        const TiltStreamModel(
          position: Offset(5, 5),
          gesturesType: GesturesType.touch,
          gestureUse: false,
        ),
      );

      /// hover 手势移动
      gestureMoveExpect = null;
      tiltStreamModelExpect = const TiltStreamModel(
        position: Offset(10, 10),
        gesturesType: GesturesType.hover,
        gestureUse: true,
      );
      tiltStreamController.sink.add(tiltStreamModelExpect);
      await tester.pumpAndSettle();
      expect(tiltStreamModelTest, tiltStreamModelExpect);
      expect(tiltStreamModelTest, gestureMoveExpect);
    });
  });
}
