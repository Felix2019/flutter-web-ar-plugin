import 'package:flutter_web_xr/src/webxr/interop/xr_frame.dart';
import 'package:js/js.dart';

@JS('XRWebGLLayer')
class XRWebGLLayer {
  external XRWebGLLayer(Object? session, Object? context);

  external getViewport(XRFrame view);
  external get context;
  external get framebuffer;
  external int get framebufferWidth;
  external int get framebufferHeight;
  external bool get ignoreDepthValues;
  external bool get antialias;
}
