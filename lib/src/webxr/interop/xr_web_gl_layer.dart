import 'package:js/js.dart';

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
