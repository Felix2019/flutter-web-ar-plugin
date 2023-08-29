import 'package:flutter_web_xr/battery_manager.dart';
import 'package:flutter_web_xr/web_xr_manager.dart';
import 'package:flutter_web_xr/xr_session.dart';
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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<MyBatteryManager> getBatteryLevel() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<dynamic> isWebXrAvailable() {
    throw UnimplementedError("WebXR-API not available");
  }

  Future<dynamic> requestSession() {
    throw UnimplementedError("requestSession() has not been implemented.");
  }

  void test(String message) {
    throw UnimplementedError("Test function is not available");
  }

  void jsTest() {
    throw UnimplementedError("JS function is not available");
  }
}
