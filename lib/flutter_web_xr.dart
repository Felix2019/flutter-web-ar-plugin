import 'flutter_web_xr_platform_interface.dart';

class FlutterWebXr {
  String? getPlatformVersion() {
    return FlutterWebXrPlatform.instance.getPlatformVersion();
  }

  Future<double> getBatteryLevel() {
    return FlutterWebXrPlatform.instance.getBatteryLevel();
  }

  bool isWebXrAvailable() {
    return FlutterWebXrPlatform.instance.isWebXrAvailable();
  }

  Future<void> startSession() {
    return FlutterWebXrPlatform.instance.startSession();
  }

  Future<void> endSession() {
    return FlutterWebXrPlatform.instance.endSession();
  }

  void createCube() {
    return FlutterWebXrPlatform.instance.createCube();
  }

  void jsPrint(String message) {
    return FlutterWebXrPlatform.instance.jsPrint(message);
  }

  void test() {
    return FlutterWebXrPlatform.instance.test();
  }
}
