import 'package:flutter_web_xr/web_xr_manager.dart';
import 'package:js/js.dart';

// @JS()
// class XR {
//   external bool get enabled;
//   external set enabled(bool value);

//   external bool get isPresenting;
//   external set isPresenting(bool value);

//   external XRSession getSession();
//   external dynamic getController(num index);
// }

@JS('navigator.xr')
external XRSystem? get xrSystem;

bool isWebXrSupported() => xrSystem != null;

@JS("XRSystem")
class XRSystem {
  external XRSession requestSession(String mode);
  external bool isSessionSupported(String mode);
}

@JS('navigator.xr.requestSession')
external dynamic startSession(String sessionType);
