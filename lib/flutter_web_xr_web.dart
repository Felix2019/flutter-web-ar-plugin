// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:flutter_web_xr/battery_manager.dart';
import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter_web_xr/src/threejs/models/scene_controller.dart';
import 'package:flutter_web_xr/src/webxr/interop/core.dart';
import 'package:flutter_web_xr/src/webxr/models/xr_controller.dart';
import 'package:flutter_web_xr/utils.dart';
import 'package:flutter_web_xr/src/threejs/interop/transformations.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:js_util';

import 'flutter_web_xr_platform_interface.dart';

/// A web implementation of the FlutterWebXrPlatform of the FlutterWebXr plugin.
class FlutterWebXrWeb extends FlutterWebXrPlatform {
  FlutterWebXrWeb();

  final XRController xrController = XRController();
  // final SceneController sceneController = SceneController();

  static void registerWith(Registrar registrar) {
    FlutterWebXrPlatform.instance = FlutterWebXrWeb();
  }

  //Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async => html.window.navigator.userAgent;

  /// Determines if the current browser is compatible based on the user agent string.
  ///
  /// This method checks if the user agent string contains identifiers for
  /// either the Chrome or Edge browser, suggesting that the environment is
  /// either a Chrome or Edge browser which are deemed compatible.
  ///
  /// @param userAgent The user agent string to be checked for compatibility.
  /// @return `true` if the browser is either Chrome or Edge, otherwise `false`.
  bool isBrowserCompatible(String userAgent) =>
      userAgent.contains('Chrome') || userAgent.contains('Edg');

  // The viewport is less than 768 pixels wide
  /// Determines if the current device is a mobile device based on its width.
  ///
  /// This method checks the window's width and considers any device
  /// with a width of 767 pixels or less to be a mobile device.
  ///
  /// @return `true` if the device is mobile (width <= 767px), otherwise `false`.
  bool isMobileDevice() => html.window.matchMedia("(max-width: 767px)").matches;

  /// Checks if WebXR is available and compatible on the current platform.
  ///
  /// This method first verifies whether WebXR is fundamentally supported.
  /// If supported, additional checks for browser compatibility and device type (mobile) are performed.
  ///
  /// @return A `Future<bool>` that returns true if WebXR is available
  /// and compatible; otherwise `false`.
  @override
  Future<bool> isWebXrAvailable() async {
    bool isWebXrAvailable = isWebXrSupported();

    if (isWebXrAvailable) {
      String userAgent =
          await getPlatformVersion() ?? 'Unknown platform version';

      bool isCompatible = isBrowserCompatible(userAgent) && isMobileDevice();
      return isCompatible;
    } else {
      return false;
    }
  }

  @override
  Future<void> endSession() async {
    try {
      await xrController.endSession();
    } catch (e) {
      throw Exception('Failed to end session');
    }
  }

  @override
  void createCube() {
    xrController.addElement();
    // final BoxGeometry geometry = BoxGeometry(1, 1, 1);
    // final BoxGeometry geometry = BoxGeometry(0.2, 0.2, 0.2);

    // final materials = [
    //   MeshBasicMaterial(jsify({'color': 0xff0000})),
    //   MeshBasicMaterial(jsify({'color': 0x0000ff})),
    //   MeshBasicMaterial(jsify({'color': 0x00ff00})),
    //   MeshBasicMaterial(jsify({'color': 0xff00ff})),
    //   MeshBasicMaterial(jsify({'color': 0x00ffff})),
    //   MeshBasicMaterial(jsify({'color': 0xffff00}))
    // ];

    // final Mesh object = Mesh(geometry, materials);
    // // object.position.x = 0;
    // // object.position.y = 0;
    // object.position.z = -1;

    // object.rotation.x += 7;
    // object.rotation.y += 7;

    // xrController.sceneController.addElement(object);
  }

  void multiplyObject() {
    const rowCount = 4;
    const half = rowCount / 2;

    final BoxGeometry geometry = BoxGeometry(0.2, 0.2, 0.2);
    // final BoxGeometry geometry = BoxGeometry(2, 2, 2);

    final materials = [
      MeshBasicMaterial(jsify({'color': 0xff0000})),
      MeshBasicMaterial(jsify({'color': 0x0000ff})),
      MeshBasicMaterial(jsify({'color': 0x00ff00})),
      MeshBasicMaterial(jsify({'color': 0xff00ff})),
      MeshBasicMaterial(jsify({'color': 0x00ffff})),
      MeshBasicMaterial(jsify({'color': 0xffff00}))
    ];

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < rowCount; j++) {
        for (var k = 0; k < rowCount; k++) {
          final Mesh object = Mesh(geometry, materials);

          object.position.x = i - half;
          object.position.y = j - half;
          object.position.z = k - half;

          domLog(object.position);

          object.rotation.x += 7;
          object.rotation.y += 7;

          xrController.sceneController.addElement(object);
          // sceneController.addElement(object);
        }
      }
    }
  }

  html.DivElement overlay = html.DivElement()
    ..id = 'ar-overlay'
    ..style.position = 'absolute'
    ..style.top = '0'
    ..style.left = '0'
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.zIndex = '100000'
    ..style.backgroundColor = "red"
    ..innerText = 'Hier ist das AR DOM Overlay!';

  @override
  Future<void> startSession() async {
    try {
      // multiplyObject();

      // createCube();

      await xrController.requestSession();
      xrController.startFrameHandler();

      // html.document.body!.children.add(overlay);

      // overlay.onClick.listen((event) {
      //   print('Overlay angeklickt!');
      // });

      // createCube();
      // xrController.rendererController.render();

      // Future.delayed(Duration(seconds: 2), () async {
      //   createCube();
      // });
    } catch (e) {
      throw Exception('operation failed');
    }
  }

  Future initSession() async {
    // call from web xr manager
  }

  @override
  void jsPrint(dynamic message) => domLog(message);

  @override
  void test() {
    jsPrint("test function");
    var pos = Position(2, 2, 2);

    // log(pos.x);

    // jsObj.getSet1 = 2;
    // var a = jsObj.getSet;
    // jsObj.method();
    // var myObject1 = MyObject()
    // myObject1.x = 10;
    // myObject1.y = 20;

    // print(stringify(myObject1));
  }

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
