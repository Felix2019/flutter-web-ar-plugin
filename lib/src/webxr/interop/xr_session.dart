import 'package:js/js.dart';

@JS()
@anonymous
class XRSessionInit {
  external factory XRSessionInit({bool immersiveAr});
}

@JS('XRSession')
class XRSession {
  external requestReferenceSpace(String type);
  external void updateRenderState(dynamic state);
  external void requestAnimationFrame(Function callback);
  external void end();

  // this.xrSession.renderState.baseLayer.framebuffer
  // external XRWebGLLayer get baseLayer;
  // external String? domOverlayState;
  external get renderState;
}
