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

  Future<double> getBatteryLevel() {
    throw UnimplementedError('getBatteryLevel() has not been implemented.');
  }

  Future<bool> isWebXrAvailable() {
    throw UnimplementedError("isWebXrAvailable() has not been implemented.");
  }

  Future<dynamic> requestSession() {
    throw UnimplementedError("requestSession() has not been implemented.");
  }

  void jsPrint(dynamic message) {
    throw UnimplementedError("log() has not been implemented.");
  }

  void test() {
    throw UnimplementedError("test() has not been implemented.");
  }
}
