import 'package:flutter_web_xr/src/webxr/interop/core.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_session.dart';
import 'package:js/js.dart';

@JS('XRFrame')
class XRFrame {
  external XRViewerPose getViewerPose(XRReferenceSpace referenceSpace);
  external XRSession get xrSession;
}

@JS('XRViewerPose')
class XRViewerPose {
  external List<XRFrame> get views;
}
