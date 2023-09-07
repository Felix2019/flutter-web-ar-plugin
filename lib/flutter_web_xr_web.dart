// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:js_interop';

import 'package:flutter_web_xr/battery_manager.dart';
import 'package:flutter_web_xr/web_xr_manager.dart';
import 'package:flutter_web_xr/test.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:js_util';

import 'flutter_web_xr_platform_interface.dart';

/// A web implementation of the FlutterWebXrPlatform of the FlutterWebXr plugin.
class FlutterWebXrWeb extends FlutterWebXrPlatform {
  FlutterWebXrWeb();

  static void registerWith(Registrar registrar) {
    FlutterWebXrPlatform.instance = FlutterWebXrWeb();
  }

  //Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  Future<bool> isWebXrAvailable() async {
    return isWebXrSupported();
  }

  @override
  Future<double> getBatteryLevel() async {
    try {
      // converts a javascript promise to a dart future
      final Future<BatteryManager> batteryFuture =
          promiseToFuture<BatteryManager>(getBattery());

      final BatteryManager batteryManager = await batteryFuture;

      double level = getProperty(batteryManager, 'level');
      return level;
    } catch (e) {
      throw Exception('Failed to fetch battery level');
    }
  }

  @override
  Future<Object> requestSession() async {
    bool result =
        await promiseToFuture(xrSystem!.isSessionSupported('immersive-ar'));

    if (!result) {
      throw Exception('WebXR not supported');
    }

    final sessionFuture =
        await promiseToFuture(xrSystem!.requestSession("immersive-ar"));

    return sessionFuture;
  }

  @override
  void test(String message) async {
    test1(message);
  }

  @override
  void jsTest() async {
    var myObject1 = MyObject();
    myObject1.x = 10;
    myObject1.y = 20;

    print(stringify(myObject1));
  }
}
