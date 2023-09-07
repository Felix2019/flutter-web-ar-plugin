import 'package:flutter_web_xr/battery_manager.dart';
import 'package:flutter_web_xr/web_xr_manager.dart';
import 'package:flutter_web_xr/xr_session.dart';

import 'flutter_web_xr_platform_interface.dart';

class FlutterWebXr {
  // static Future<LocationPermission> checkPermission() =>
  //     GeolocatorPlatform.instance.checkPermission();

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

  test(String message) {
    return FlutterWebXrPlatform.instance.test(message);
  }

  jsTest() {
    return FlutterWebXrPlatform.instance.jsTest();
  }
}
