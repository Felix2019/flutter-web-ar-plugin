@JS('THREE')
library three;

import 'package:js/js.dart';
import 'dart:html' as html;

@JS('Scene')
class Scene {
  external Scene();
  external add(dynamic object);
}

@JS('PerspectiveCamera')
class PerspectiveCamera {
  external PerspectiveCamera(num fov, num aspect, num near, num far);
  external Position get position;
  external set position(Position value);
}

@JS()
class Position {
  external Position(num x, num y, num z);

  external num get x;
  external set x(num value);

  external num get y;
  external set y(num value);

  external num get z;
  external set z(num value);
}

@JS('WebGLRenderer')
class WebGLRenderer {
  external WebGLRenderer([Map options]);
  external void setSize(num width, num height);
  external html.Element get domElement;
  external void render(dynamic scene, dynamic camera);
}

@JS('BoxGeometry')
class BoxGeometry {
  external BoxGeometry(num width, num height, num depth);
}

@JS('MeshBasicMaterial')
class MeshBasicMaterial {
  external MeshBasicMaterial(dynamic parameters);
}

@JS('Mesh')
class Mesh {
  external Mesh(dynamic geometry, dynamic material);
}
