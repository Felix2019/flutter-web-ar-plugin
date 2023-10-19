// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:flutter_web_xr/battery_manager.dart';
import 'package:flutter_web_xr/src/threejs/interop/geometries.dart';
import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter_web_xr/src/threejs/controllers/camera_controller.dart';
import 'package:flutter_web_xr/src/threejs/controllers/loader_controller.dart';
import 'package:flutter_web_xr/src/threejs/controllers/renderer_controller.dart';
import 'package:flutter_web_xr/src/threejs/controllers/scene_controller.dart';
import 'package:flutter_web_xr/src/threejs/three_utils.dart';
import 'package:flutter_web_xr/src/webxr/controllers/xr_controller.dart';
import 'package:flutter_web_xr/src/utils/interop_utils.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:js_util';

import 'flutter_web_xr_platform_interface.dart';

/// A web implementation of the FlutterWebXrPlatform of the FlutterWebXr plugin.
class FlutterWebXrWeb extends FlutterWebXrPlatform {
  late XRController xrController;
  late RendererController rendererController;

  final html.CanvasElement canvas = html.CanvasElement()
    ..style.width = '100%'
    ..style.height = '100%';

  final SceneController sceneController = SceneController();
  final CameraController cameraController =
      CameraController(matrixAutoUpdate: false);
  final LoaderController loaderController = LoaderController();

  /// Constructor for `FlutterWebXrWeb`. Initializes XRController and other members.
  FlutterWebXrWeb() {
    try {
      rendererController = RendererController(canvas: canvas);

      xrController =
          XRController(rendererController, sceneController, cameraController);
    } catch (e) {
      throw Exception('Failed to instantiate XRController: $e');
    }
  }

  /// Register this web platform implementation.
  static void registerWith(Registrar registrar) {
    FlutterWebXrPlatform.instance = FlutterWebXrWeb();
  }

  //Returns a [String] containing the version of the platform.
  @override
  String? getPlatformVersion() => html.window.navigator.userAgent;

  /// Determines if the current browser is compatible based on the user agent string.
  ///
  /// This method checks if the user agent string contains identifiers for
  /// either the Chrome or Edge browser, suggesting that the environment is
  /// either a Chrome or Edge browser which are deemed compatible.
  ///
  /// @param userAgent The user agent string to be checked for compatibility.
  /// @return `true` if the browser is either Chrome or Edge, otherwise `false`.
  bool isBrowserCompatible(String userAgent) =>
      userAgent.toLowerCase().contains('chrome') ||
      userAgent.toLowerCase().contains('edg');

  /// Checks if the viewport is less than 768 pixels wide indicating a mobile device.
  bool isMobileDevice() => html.window.matchMedia("(max-width: 767px)").matches;

  /// Checks if WebXR is available and compatible on the current platform.
  ///
  /// This method first verifies whether WebXR is fundamentally supported.
  /// If supported, additional checks for browser compatibility and device type (mobile) are performed.
  ///
  /// @return A `Future<bool>` that returns true if WebXR is available
  /// and compatible; otherwise `false`.
  @override
  bool isWebXrAvailable() {
    bool isWebXrAvailable = xrController.isWebXrSupported();

    if (!isWebXrAvailable) return false;
    return checkRequirements();
  }

  /// Helper function to check browser compatibility and device requirements.
  bool checkRequirements() {
    String userAgent = getPlatformVersion() ?? 'Unknown platform version';

    bool isCompatible = isBrowserCompatible(userAgent) && isMobileDevice();
    return isCompatible;
  }

  /// Creates and returns a mesh object with the specified geometry and materials.
  @override
  Mesh createObject(dynamic geometry,
      [List<MeshBasicMaterial>? materials, Map<String, dynamic>? options]) {
    final dynamic object =
        Mesh(geometry, materials ?? ThreeUtils.createMaterials());
    object.position.z = -1;
    object.rotation.x += 7;
    object.rotation.y += 7;

    if (options != null) {
      if (options['scale'] != null) {
        object.scale.set(options['scale']['x'], options['scale']['y'],
            options['scale']['z']);
      }
    }

    sceneController.addElement(object);
    return object;
  }

  /// Creates and returns a cube mesh.
  @override
  Mesh createCube(
      {required double sideLength, List<MeshBasicMaterial>? materials}) {
    final BoxGeometry geometry =
        BoxGeometry(sideLength, sideLength, sideLength);
    return createObject(geometry, materials);
  }

  /// Creates and returns a cone mesh.
  @override
  Mesh createCone(
      {required double radius,
      required double height,
      List<MeshBasicMaterial>? materials}) {
    final ConeGeometry geometry = ConeGeometry(radius, height, 32);

    return createObject(geometry, materials);
  }

  /// Creates and returns a heart-shaped mesh.
  @override
  Mesh createHeart({required int color}) {
    final Shape shape = Shape();
    shape.moveTo(25, 25);
    shape.bezierCurveTo(25, 25, 20, 0, 0, 0);
    shape.bezierCurveTo(-30, 0, -30, 35, -30, 35);
    shape.bezierCurveTo(-30, 55, -10, 77, 25, 95);
    shape.bezierCurveTo(60, 77, 80, 55, 80, 35);
    shape.bezierCurveTo(80, 35, 80, 0, 50, 0);
    shape.bezierCurveTo(35, 0, 25, 25, 25, 25);

    final Map<String, dynamic> extrudeSettings = {
      "depth": 8,
      "bevelEnabled": true,
      "bevelSegments": 2,
      "steps": 2,
      "bevelSize": 1,
      "bevelThickness": 1
    };

    final MeshBasicMaterial material =
        MeshBasicMaterial(jsify({'color': color}));

    final Map<String, dynamic> options = {
      'scale': {'x': 0.01, 'y': 0.01, 'z': 0.01}
    };

    final ExtrudeGeometry geometry =
        ExtrudeGeometry(shape, jsify(extrudeSettings));

    return createObject(geometry, [material], options);
  }

  /// Initiates a WebXR session.
  @override
  Future<void> startSession() async {
    try {
      await xrController.requestSession();
      xrController.startFrameHandler();
    } catch (e) {
      throw Exception('Failed to start xr session');
    }
  }

  /// Ends a WebXR session.
  @override
  Future<void> endSession() async {
    try {
      await xrController.endSession();
    } catch (e) {
      throw Exception('Failed to end session');
    }
  }

  /// Loads a GLTF model from the specified path and adds it to the scene.
  @override
  Future<void> loadGLTFModel(String path) async {
    try {
      dynamic model = await loaderController.loadModel(path);

      model.scale.set(0.5, 0.5, 0.5);
      model.position.z = -1;
      sceneController.addElement(model);

      rendererController.render(
          sceneController.scene, cameraController.perspectiveCamera);
    } catch (e) {
      throw Exception('Failed to load gltf model');
    }
  }

  /// Opens a new browser window/tab with the specified URL.
  @override
  void openWindow(String url) => html.window.open(url, '_blank');

  /// Prints a message to the JavaScript console.
  @override
  void jsPrint(dynamic message) => domLog(message);

  /// Retrieves the battery level of the device.
  ///
  /// This method makes use of the `getBattery` function (assumed to be defined elsewhere)
  /// which fetches the battery information. It then retrieves the battery level property
  /// from the returned battery manager.
  ///
  /// The method will attempt to convert the JavaScript promise returned by `getBattery`
  /// into a Dart future. If any step in this process fails, an exception will be thrown
  /// with a message indicating failure to fetch the battery level.
  ///
  /// @return A `Future` that resolves to a `double` value representing the battery level.
  /// The value is between 0.0 (fully discharged) to 1.0 (fully charged).
  ///
  /// @throws Exception if there's a failure in fetching the battery level or converting
  /// the JavaScript promise.
  @override
  Future<double> getBatteryLevel() async {
    try {
      // converts a javascript promise to a dart future
      final Future<BatteryManager> batteryFuture =
          promiseToFuture<BatteryManager>(getBattery());

      final BatteryManager batteryManager = await batteryFuture;

      final double level = getProperty(batteryManager, 'level');
      return level;
    } catch (e) {
      throw Exception('Failed to fetch battery level');
    }
  }
}
