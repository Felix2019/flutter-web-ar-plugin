@JS()
library webxr_manager;

import 'package:js/js.dart';

@JS('navigator.xr')
external XRSystem? get xrSystem;

@JS("XRSystem")
class XRSystem {
  external XRSession requestSession(String mode);
  external bool isSessionSupported(String mode);
}

bool isWebXrSupported() => xrSystem != null;

@JS('navigator.xr.requestSession')
external dynamic startSession(String sessionType);

@JS()
@anonymous
class XRSessionInit {
  external factory XRSessionInit({bool immersiveAr});
}

@JS('XRWebGLLayer')
class XRWebGLLayer {
  external XRWebGLLayer(Object? session, Object? context);

  external get context;
  external get framebuffer;
  external int get framebufferWidth;
  external int get framebufferHeight;
  external bool get ignoreDepthValues;
  external bool get antialias;
}

@JS('XRSession')
class XRSession {
  external requestReferenceSpace(String type);
  external void updateRenderState(dynamic state);
  external void requestAnimationFrame(Function callback);
  external void end();

  // this.xrSession.renderState.baseLayer.framebuffer
  // external XRWebGLLayer get baseLayer;
  external get renderState;
}

// @JS('XRRenderState')
// class XRRenderState {
//   external requestReferenceSpace(String type);
//   external void updateRenderState(dynamic state);
//   external void requestAnimationFrame(Function callback);
//   external void end();

//   // this.xrSession.renderState.baseLayer.framebuffer
//   // external XRWebGLLayer get baseLayer;
//   external get renderState;
// }

@JS()
@anonymous
class XRRenderStateInit {
  external factory XRRenderStateInit({XRWebGLLayer baseLayer});
}
