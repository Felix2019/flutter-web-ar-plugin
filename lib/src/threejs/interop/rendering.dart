@JS('THREE')
library rendering;

import 'package:flutter_web_xr/src/threejs/interop/transformations.dart';
import 'package:js/js.dart';

import 'utilities.dart';

@JS('PerspectiveCamera')
class PerspectiveCamera {
  external PerspectiveCamera([num fov, num aspect, num near, num far]);
  external Position get position;
  external set position(Position value);
  external set matrixAutoUpdate(bool value);
  external bool get matrixAutoUpdate;
  external void updateMatrixWorld(bool value);
  external void updateProjectionMatrix();
  external void lookAt(Position vector);
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
