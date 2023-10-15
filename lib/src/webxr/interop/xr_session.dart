import 'package:flutter_web_xr/src/webxr/interop/core.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_render_state.dart';
import 'package:js/js.dart';

@JS('XRSession')
class XRSession {
  external Future<XRReferenceSpace> requestReferenceSpace(
      String referenceSpaceType);
  external void updateRenderState(XRRenderStateInit state);
  external void requestAnimationFrame(Function callback);
  external Future<void> end();
  external XRRenderState renderState;
  external dynamic get domOverlayState;
}
