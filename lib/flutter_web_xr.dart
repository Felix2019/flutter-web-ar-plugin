import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'flutter_web_xr_platform_interface.dart';

/// Represents the main class for the FlutterWebXr functionality.
/// This class acts as a facade for the `FlutterWebXrPlatform` instance,
/// providing a convenient interface to access WebXR functionalities
/// without directly interacting with the underlying platform code.
class FlutterWebXr {
  /// Retrieves the platform version.
  ///
  /// @return A [String] containing the version of the platform.
  String? getPlatformVersion() {
    return FlutterWebXrPlatform.instance.getPlatformVersion();
  }

  /// Fetches the current battery level of the device.
  ///
  /// @return A [Future] that resolves to a [double] representing the battery level.
  Future<double> getBatteryLevel() {
    return FlutterWebXrPlatform.instance.getBatteryLevel();
  }

  /// Checks if WebXR is available on the current platform.
  ///
  /// @return A [bool] indicating whether WebXR is available.
  bool isWebXrAvailable() {
    return FlutterWebXrPlatform.instance.isWebXrAvailable();
  }

  /// Initiates a WebXR session.
  ///
  /// @return A [Future] indicating the session start process completion.
  Future<void> startSession() {
    return FlutterWebXrPlatform.instance.startSession();
  }

  /// Ends the current WebXR session.
  ///
  /// @return A [Future] indicating the session end process completion.
  Future<void> endSession() {
    return FlutterWebXrPlatform.instance.endSession();
  }

  /// Creates a 3D object using the given geometry, materials, and options.
  ///
  /// @param geometry The geometry of the object.
  /// @param materials An optional list of materials to be applied to the object.
  /// @param options Additional options for object creation.
  ///
  /// @return A [Mesh] object representing the created 3D object.
  Mesh createObject(dynamic geometry,
      [List<MeshBasicMaterial>? materials, Map<String, dynamic>? options]) {
    return FlutterWebXrPlatform.instance
        .createObject(geometry, materials, options);
  }

  /// Creates a 3D cube using the given side length and materials.
  ///
  /// @param sideLength The length of each side of the cube.
  /// @param materials An optional list of materials to be applied to the cube.
  ///
  /// @return A [Mesh] object representing the created cube.
  Mesh createCube(
      {required double sideLength, List<MeshBasicMaterial>? materials}) {
    return FlutterWebXrPlatform.instance
        .createCube(sideLength: sideLength, materials: materials);
  }

  /// Creates a 3D cone using the given radius, height, and materials.
  ///
  /// @param radius The radius of the base of the cone.
  /// @param height The height of the cone.
  /// @param materials An optional list of materials to be applied to the cone.
  ///
  /// @return A [Mesh] object representing the created cone.
  Mesh createCone(
      {required double radius,
      required double height,
      List<MeshBasicMaterial>? materials}) {
    return FlutterWebXrPlatform.instance
        .createCone(radius: radius, height: height, materials: materials);
  }

  /// Creates a 3D heart shape with the specified color.
  ///
  /// @param color The color of the heart.
  ///
  /// @return A [Mesh] object representing the created heart.
  Mesh createHeart({required int color}) {
    return FlutterWebXrPlatform.instance.createHeart(color: color);
  }

  /// Loads a 3D model in GLTF format from the specified path.
  ///
  /// @param path The path to the GLTF model file.
  ///
  /// @return A [Future] indicating the completion of the model loading process.
  Future<void> loadGLTFModel(String path) async {
    return await FlutterWebXrPlatform.instance.loadGLTFModel(path);
  }

  /// Prints the specified message using the platform's JavaScript console.
  ///
  /// @param message The message to print.
  void jsPrint(String message) {
    return FlutterWebXrPlatform.instance.jsPrint(message);
  }

  /// Opens a new browser window or tab with the specified URL.
  ///
  /// @param url The URL to be opened.
  void openWindow(String url) {
    return FlutterWebXrPlatform.instance.openWindow(url);
  }
}
