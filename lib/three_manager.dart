@JS('THREE')
library three;

import 'package:flutter_web_xr/web_xr_manager.dart';
import 'package:js/js.dart';
import 'dart:html' as html;

@JS('Scene')
class Scene {
  external Scene();
  external add(dynamic object);
  external set background(Color? color);
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

@JS()
class XR {
  external bool get enabled;
  external set enabled(bool value);

  external bool get isPresenting;
  external set isPresenting(bool value);

  external XRSession getSession();
  external dynamic getController(num index);
}

@JS('WebGLRenderer')
class WebGLRenderer {
  external WebGLRenderer([Object options]);
  external void setSize(num width, num height);
  external html.CanvasElement get domElement;
  external void render(dynamic scene, dynamic camera);
  external XR get xr;
  // renderer.setClearColor(0x000000, 1.0);
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
  external Rotation get rotation;
}

@JS()
class Rotation {
  external Rotation(num x, num y, num z);

  external num get x;
  external set x(num value);

  external num get y;
  external set y(num value);

  external num get z;
  external set z(num value);
}

@JS()
class Color {
  external Color(dynamic value, [dynamic a, dynamic b, dynamic c]);
}
