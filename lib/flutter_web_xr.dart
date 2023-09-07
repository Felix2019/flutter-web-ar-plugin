import 'flutter_web_xr_platform_interface.dart';

class FlutterWebXr {
  Future<String?> getPlatformVersion() {
    return FlutterWebXrPlatform.instance.getPlatformVersion();
  }

  Future<double> getBatteryLevel() {
    return FlutterWebXrPlatform.instance.getBatteryLevel();
  }

  Future<bool> isWebXrAvailable() {
    return FlutterWebXrPlatform.instance.isWebXrAvailable();
  }

  Future<dynamic> requestSession() {
    return FlutterWebXrPlatform.instance.requestSession();
  }

  void log(String message) {
    return FlutterWebXrPlatform.instance.log(message);
  }

  void test() {
    return FlutterWebXrPlatform.instance.test();
  }
}
