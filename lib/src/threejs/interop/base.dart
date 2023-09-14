@JS('THREE')
library base;

import 'dart:html' as html;

// import 'package:flutter_web_xr/src/webxr/core.dart';
import 'package:flutter_web_xr/utils.dart';
import 'package:js/js.dart';

@JS('Object3D')
class Object3D {
  external factory Object3D();
}

@JS('WebGLRenderer')
class WebGLRenderer {
  external factory WebGLRenderer([Object options]);
  external html.CanvasElement get domElement;
  external void render(dynamic scene, dynamic camera);
  // external XR get xr;
  external void setSize(num width, num height);
  external set autoClear(bool value);
  external clear([bool color, bool depth, bool stencil]);
  external WebGL2RenderingContext getContext();
  external void dispose();
}
