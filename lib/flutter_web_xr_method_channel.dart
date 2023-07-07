import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_web_xr_platform_interface.dart';

/// An implementation of [FlutterWebXrPlatform] that uses method channels.
class MethodChannelFlutterWebXr extends FlutterWebXrPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_web_xr');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
