import 'package:flutter_web_xr/src/webxr/interop/xr_session.dart';
import 'package:js/js.dart';

@JS('navigator.xr')
external XRSystem? get xrSystem;

@JS("XRSystem")
class XRSystem {
  external XRSession requestSession(String mode, Object options);
  external bool isSessionSupported(String mode);
}

@JS('XRReferenceSpace')
class XRReferenceSpace {}

@JS('XRViewport')
class XRViewport {
  external int get height;
  external int get width;
}

@JS('XRRigidTransform')
class XRRigidTransform {
  external get position;
  external get orientation;
  external List<double> matrix;
}

// not used currently
@JS()
class XR {
  external bool get enabled;
  external set enabled(bool value);

  external bool get isPresenting;
  external set isPresenting(bool value);

  external XRSession getSession();
  external dynamic getController(num index);
}
