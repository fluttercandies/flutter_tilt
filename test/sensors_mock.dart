import 'package:flutter/services.dart' show StandardMethodCodec, ByteData;
import 'package:flutter_test/flutter_test.dart'
    show TestDefaultBinaryMessengerBinding, fail;

/// 传感器模拟
///
/// 在测试中使用模拟传感器数据，避免依赖真实硬件设备。
///
/// 在 Widget 测试前，需要先初始化 [initMockSensorsMethodChannel] 和 [initMockSensorChannelData]。
///
/// 示例：
/// ```dart
/// SensorsMock.initMockSensorsMethodChannel([
///   SensorsMock.accelerometerMethodName,
///   SensorsMock.gyroscopeMethodName,
/// ]);
/// final date = DateTime.now();
/// final List<List<double>> accelerometerSensorData = [
///   [1.0, 2.0, 3.0, date.microsecondsSinceEpoch.toDouble()],
/// ];
/// final List<List<double>> gyroscopeSensorData = [
///   [3.0, 4.0, 5.0, date.microsecondsSinceEpoch.toDouble()],
/// ];
/// SensorsMock.initMockSensorChannelData(
///   SensorsMock.accelerometerChannelName,
///   accelerometerSensorData,
/// );
/// SensorsMock.initMockSensorChannelData(
///   SensorsMock.gyroscopeChannelName,
///   gyroscopeSensorData,
/// );
/// ```
abstract final class SensorsMock {
  static const sensorsChannelName = 'dev.fluttercommunity.plus/sensors/method';

  static const accelerometerChannelName =
      'dev.fluttercommunity.plus/sensors/accelerometer';
  static const accelerometerMethodName = 'setAccelerationSamplingPeriod';

  static const gyroscopeChannelName =
      'dev.fluttercommunity.plus/sensors/gyroscope';
  static const gyroscopeMethodName = 'setGyroscopeSamplingPeriod';

  /// 初始化模拟 Sensors Method Channel
  ///
  /// - [methodNames] 支持的方法名称列表，
  ///   例如 [accelerometerMethodName]、[gyroscopeMethodName]
  static void initMockSensorsMethodChannel(List<String> methodNames) {
    const standardMethod = StandardMethodCodec();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      sensorsChannelName,
      (ByteData? message) async {
        final methodCall = standardMethod.decodeMethodCall(message);
        if (methodNames.contains(methodCall.method)) {
          return standardMethod.encodeSuccessEnvelope(null);
        } else {
          fail('Expected ${methodCall.method}');
        }
      },
    );
  }

  /// 初始化模拟 Sensor Channel 数据
  ///
  /// - [channelName] 传感器通道名称，
  ///   例如 [accelerometerChannelName] 或 [gyroscopeChannelName]
  /// - [sensorDataList] 模拟多组传感器数据，
  ///   例如 [[1.0, 2.0, 3.0, datetime.microsecondsSinceEpoch.toDouble()]]
  static void initMockSensorChannelData(
    String channelName,
    List<List<double>> sensorDataList,
  ) {
    const standardMethod = StandardMethodCodec();

    void emitEvent(ByteData? event) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
        channelName,
        event,
        (ByteData? reply) {},
      );
    }

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(channelName, (ByteData? message) async {
      final methodCall = standardMethod.decodeMethodCall(message);
      if (methodCall.method == 'listen') {
        for (final sensorData in sensorDataList) {
          emitEvent(standardMethod.encodeSuccessEnvelope(sensorData));
        }
        emitEvent(null);
        return standardMethod.encodeSuccessEnvelope(null);
      } else if (methodCall.method == 'cancel') {
        return standardMethod.encodeSuccessEnvelope(null);
      } else {
        fail('Expected listen or cancel');
      }
    });
  }
}
