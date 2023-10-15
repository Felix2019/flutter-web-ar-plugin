@JS('THREE')
library utilities;

import 'package:flutter_web_xr/src/webxr/interop/xr_session.dart';
import 'package:js/js.dart';

@JS('Object3D')
class Object3D {
  external factory Object3D();
}

@JS('WebXRManager')
class WebXRManager {
  external bool get enabled;
  external set enabled(bool value);
  external bool get isPresenting;
  external set isPresenting(bool value);
  external XRSession getSession();
  external dynamic getController(int index);
}

@JS('Matrix4')
class Matrix4 {
  external Matrix4();
  external Future<void> fromArray(dynamic value);
}

@JS()
class Color {
  external Color(dynamic value, [dynamic a, dynamic b, dynamic c]);
}
