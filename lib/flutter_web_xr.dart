import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';

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

  void createObject(dynamic geometry, [List<MeshBasicMaterial>? materials]) {
    return FlutterWebXrPlatform.instance.createObject(geometry, materials);
  }

  void createCube(
      {required double sideLength, List<MeshBasicMaterial>? materials}) {
    return FlutterWebXrPlatform.instance
        .createCube(sideLength: sideLength, materials: materials);
  }

  void createCone(
      {required double radius,
      required double height,
      List<MeshBasicMaterial>? materials}) {
    return FlutterWebXrPlatform.instance
        .createCone(radius: radius, height: height, materials: materials);
  }

  void jsPrint(String message) {
    return FlutterWebXrPlatform.instance.jsPrint(message);
  }

  void openWindow(String url) {
    return FlutterWebXrPlatform.instance.openWindow(url);
  }

  void test() {
    return FlutterWebXrPlatform.instance.test();
  }
}
