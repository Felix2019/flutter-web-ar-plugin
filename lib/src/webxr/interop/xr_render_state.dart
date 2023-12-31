import 'package:flutter_web_xr/src/webxr/interop/xr_web_gl_layer.dart';
import 'package:js/js.dart';

@JS('XRRenderState')
class XRRenderState {
  external requestReferenceSpace(String type);
  external void updateRenderState(dynamic state);
  external void requestAnimationFrame(Function callback);
  external void end();
  external XRWebGLLayer get baseLayer;
}

@JS()
@anonymous
class XRRenderStateInit {
  external factory XRRenderStateInit({XRWebGLLayer baseLayer});
}
