import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_web_xr_method_channel.dart';

/// Abstract class defining the interface for FlutterWebXrPlatform.
///
/// This class provides a set of methods that should be implemented by platform-specific
/// implementations, enabling XR capabilities for Flutter applications.
abstract class FlutterWebXrPlatform extends PlatformInterface {
  /// Default constructor for the platform interface.
  FlutterWebXrPlatform() : super(token: _token);

  // A unique token used for verifying platform-specific implementations.
  static final Object _token = Object();

  // The default instance for the platform, set to use the method channel implementation.
  static FlutterWebXrPlatform _instance = MethodChannelFlutterWebXr();

  /// Returns the current instance of the FlutterWebXrPlatform.
  ///
  /// By default, it uses the [MethodChannelFlutterWebXr].
  static FlutterWebXrPlatform get instance => _instance;

  /// Sets the instance for the FlutterWebXrPlatform.
  ///
  /// Platform-specific implementations should set this with their own
  /// class that extends [FlutterWebXrPlatform] when they register themselves.
  static set instance(FlutterWebXrPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the platform version.
  String? getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Retrieves the battery level of the device.
  Future<double> getBatteryLevel() {
    throw UnimplementedError('getBatteryLevel() has not been implemented.');
  }

  /// Checks if WebXR is available on the platform.
  bool isWebXrAvailable() {
    throw UnimplementedError("isWebXrAvailable() has not been implemented.");
  }

  /// Starts a WebXR session.
  Future<void> startSession() {
    throw UnimplementedError("startSession() has not been implemented.");
  }

  /// Ends a WebXR session.
  Future<void> endSession() {
    throw UnimplementedError("endSession() has not been implemented.");
  }

  /// Creates a 3D object using the provided geometry and materials.
  Mesh createObject(dynamic geometry,
      [List<MeshBasicMaterial>? materials, Map<String, dynamic>? options]) {
    throw UnimplementedError("createObject() has not been implemented.");
  }

  /// Creates a cube with the specified side length and materials.
  Mesh createCube(
      {required double sideLength, List<MeshBasicMaterial>? materials}) {
    throw UnimplementedError("createCube() has not been implemented.");
  }

  /// Creates a cone using the given radius, height, and materials.
  Mesh createCone(
      {required double radius,
      required double height,
      List<MeshBasicMaterial>? materials}) {
    throw UnimplementedError("createCone() has not been implemented.");
  }

  /// Generates a 3D heart shape with the specified color.
  Mesh createHeart({required int color}) {
    throw UnimplementedError("createHeart() has not been implemented.");
  }

  /// Loads a 3D model in GLTF format from the provided path.
  Future<void> loadGLTFModel(String path) async {
    throw UnimplementedError("loadGLTFModel() has not been implemented.");
  }

  /// Prints a message to the JavaScript console.
  void jsPrint(dynamic message) {
    throw UnimplementedError("log() has not been implemented.");
  }

  /// Opens a new browser window or tab with the specified URL.
  void openWindow(String url) {
    throw UnimplementedError("openWindow() has not been implemented.");
  }
}
