@JS('THREE')
library rendering;

import 'package:flutter_web_xr/src/threejs/interop/transformations.dart';
import 'package:flutter_web_xr/src/utils/interop_utils.dart';
import 'package:js/js.dart';
import 'dart:html' as html;

import 'utilities.dart';

@JS('WebGLRenderer')
class WebGLRenderer {
  external factory WebGLRenderer([Object options]);
  external html.CanvasElement get domElement;
  external void render(Scene scene, dynamic camera);
  external void setSize(num width, num height);
  external set autoClear(bool value);
  external clear([bool color, bool depth, bool stencil]);
  external WebGL2RenderingContext getContext();
  external WebXRManager get xr;
  external void dispose();
}

@JS('PerspectiveCamera')
class PerspectiveCamera {
  external PerspectiveCamera([num fov, num aspect, num near, num far]);
  external Vector3 get position;
  external set position(Vector3 value);
  external set matrixAutoUpdate(bool value);
  external bool get matrixAutoUpdate;
  external void updateMatrixWorld(bool value);
  external void updateProjectionMatrix();
  external void lookAt(Vector3 vector);
  external bool get isPerspectiveCamera;
  external Matrix4 get matrix;
  external Matrix4 get projectionMatrix;
  external set quaternion(dynamic value);
}

@JS('Scene')
class Scene {
  external factory Scene();
  external void add(dynamic object);
  external void clear();
  external set background(Color? color);
}
