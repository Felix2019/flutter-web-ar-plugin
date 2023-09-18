import 'package:flutter_web_xr/src/webxr/interop/core.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_render_state.dart';
import 'package:js/js.dart';

// @JS()
// @anonymous
// class XRSessionInit {
//   external factory XRSessionInit({bool immersiveAr});
// }

@JS('XRSession')
class XRSession {
  external Future<XRReferenceSpace> requestReferenceSpace(
      String referenceSpaceType);
  external void updateRenderState(dynamic state);
  external void requestAnimationFrame(Function callback);
  external void end();

  // this.xrSession.renderState.baseLayer.framebuffer
  // external XRWebGLLayer get baseLayer;
  // external String? domOverlayState;
  external XRRenderState renderState;
}
