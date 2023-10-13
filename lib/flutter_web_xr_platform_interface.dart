import 'package:flutter/foundation.dart';
import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_web_xr_method_channel.dart';

abstract class FlutterWebXrPlatform extends PlatformInterface {
  /// Constructs a FlutterWebXrPlatform.
  FlutterWebXrPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWebXrPlatform _instance = MethodChannelFlutterWebXr();

  /// The default instance of [FlutterWebXrPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWebXr].
  static FlutterWebXrPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWebXrPlatform] when
  /// they register themselves.
  static set instance(FlutterWebXrPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  String? getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<double> getBatteryLevel() {
    throw UnimplementedError('getBatteryLevel() has not been implemented.');
  }

  bool isWebXrAvailable() {
    throw UnimplementedError("isWebXrAvailable() has not been implemented.");
  }

  Future<void> startSession() {
    throw UnimplementedError("startSession() has not been implemented.");
  }

  Future<void> endSession() {
    throw UnimplementedError("endSession() has not been implemented.");
  }

  Mesh createObject(dynamic geometry, [List<MeshBasicMaterial>? materials]) {
    throw UnimplementedError("createObject() has not been implemented.");
  }

  Mesh createCube(
      {required double sideLength, List<MeshBasicMaterial>? materials}) {
    throw UnimplementedError("createCube() has not been implemented.");
  }

  Mesh createCone(
      {required double radius,
      required double height,
      List<MeshBasicMaterial>? materials}) {
    throw UnimplementedError("createCone() has not been implemented.");
  }

  Future<void> loadGLTFModel(String path) async {
    throw UnimplementedError("loadGLTFModel() has not been implemented.");
  }

  void jsPrint(dynamic message) {
    throw UnimplementedError("log() has not been implemented.");
  }

  void openWindow(String url) {
    throw UnimplementedError("openWindow() has not been implemented.");
  }

  void test() {
    throw UnimplementedError("test() has not been implemented.");
  }
}
