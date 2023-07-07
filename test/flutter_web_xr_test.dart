import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr/flutter_web_xr_platform_interface.dart';
import 'package:flutter_web_xr/flutter_web_xr_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWebXrPlatform
    with MockPlatformInterfaceMixin
    implements FlutterWebXrPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future getBattery() {
    // TODO: implement getBattery
    throw UnimplementedError();
  }

  @override
  Future getBatteryLevel() {
    // TODO: implement getBatteryLevel
    throw UnimplementedError();
  }

  @override
  Future isWebXrApiAvailable() {
    // TODO: implement isWebXrApiAvailable
    throw UnimplementedError();
  }

  @override
  void test(String message) {
    // TODO: implement test
  }
}

void main() {
  final FlutterWebXrPlatform initialPlatform = FlutterWebXrPlatform.instance;

  test('$MethodChannelFlutterWebXr is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterWebXr>());
  });

  test('getPlatformVersion', () async {
    FlutterWebXr flutterWebXrPlugin = FlutterWebXr();
    MockFlutterWebXrPlatform fakePlatform = MockFlutterWebXrPlatform();
    FlutterWebXrPlatform.instance = fakePlatform;

    expect(await flutterWebXrPlugin.getPlatformVersion(), '42');
  });
}
